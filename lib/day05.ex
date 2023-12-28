defmodule Day05.Utils do
  def get_maps(lines) do
    lines
    |> Enum.reduce([], fn line, acc ->
      case get_source_dest(line) do
        {source, dest} ->
          [%{source: source, dest: dest, ranges: []} | acc]

        :no_match ->
          [current_mapping | rest] = acc

          [
            current_mapping
            |> Map.put(:ranges, [
              get_ranges(line) | current_mapping.ranges
            ])
            | rest
          ]
      end
    end)
    |> Enum.reduce(%{}, fn mapping, acc ->
      %{source: source, dest: dest, ranges: ranges} = mapping
      acc |> Map.put(source, %{dest: dest, ranges: ranges})
    end)
  end

  defp get_source_dest(line) do
    regex = ~r/^(.+)-to-(.+) map:$/

    case Regex.run(regex, line) do
      [_, source, dest] -> {source, dest}
      _ -> :no_match
    end
  end

  defp get_ranges(line) do
    [dest_start_str, source_start_str, length_str] = line |> String.split(" ", trim: true)
    {dest_start, _} = Integer.parse(dest_start_str)
    {source_start, _} = Integer.parse(source_start_str)
    {length, _} = Integer.parse(length_str)
    {source_start, dest_start, length}
  end

  def get_computed_value_for(value, maps) do
    get_computed_value_for(value, maps, "seed")
  end

  def get_computed_value_for(value, maps, type) do
    case maps[type] do
      nil ->
        value

      %{dest: dest, ranges: ranges} ->
        case(
          ranges
          |> Enum.find(fn {source_start, _, length} ->
            value >= source_start and value < source_start + length
          end)
        ) do
          {source_start, dest_start, _} ->
            new_value = dest_start + (value - source_start)
            get_computed_value_for(new_value, maps, dest)

          _ ->
            get_computed_value_for(value, maps, dest)
        end
    end
  end

  def get_seeds_and_rest(input) do
    [seeds_line | lines] = Utils.split_into_lines(input)
    [_, seed_numbers_str] = String.split(seeds_line, ":")

    seeds =
      seed_numbers_str
      |> String.split(" ", trim: true)
      |> Enum.map(fn seed_str ->
        {seed_val, _} = Integer.parse(seed_str)
        seed_val
      end)

    {seeds, lines}
  end
end

defmodule Day05.Part1 do
  def solve(input) do
    {seeds, lines} = Day05.Utils.get_seeds_and_rest(input)
    maps = Day05.Utils.get_maps(lines)

    seeds
    |> Enum.map(&Day05.Utils.get_computed_value_for(&1, maps))
    |> Enum.min()
  end
end

defmodule Day05.Part2 do
  def solve(input) do
    {seeds, lines} = Day05.Utils.get_seeds_and_rest(input)
    maps = Day05.Utils.get_maps(lines)

    seed_to_soil_ranges =
      maps["seed"].ranges
      |> Enum.map(fn {source_start, _, length} ->
        [source_start, length]
      end)

    seeds
    |> convert_seed_ranges_to_list(seed_to_soil_ranges)
    |> Enum.map(fn value ->
      Day05.Utils.get_computed_value_for(value, maps)
    end)
    |> Enum.min()
  end

  defp get_overlapping_values(
         search_start,
         search_length,
         target_start,
         target_length
       ) do
    search_end = search_start + search_length - 1
    target_end = target_start + target_length - 1

    overlap_start = max(search_start, target_start)
    overlap_end = min(search_end, target_end)

    if overlap_start <= overlap_end do
      {overlap_start, overlap_end - overlap_start + 1}
    else
      nil
    end
  end

  defp convert_seed_ranges_to_list(seed_ranges, target_ranges) do
    seed_ranges
    |> Enum.chunk_every(2)
    |> Enum.map(fn [range_start, range_length] ->
      target_ranges
      |> Enum.map(fn [target_start, target_length] ->
        case get_overlapping_values(
               range_start,
               range_length,
               target_start,
               target_length
             ) do
          {overlap_start, overlap_end} ->
            Enum.to_list(overlap_start..overlap_end)

          nil ->
            [range_start, range_length]
        end
      end)
    end)
    |> List.flatten()
  end
end

defmodule Mix.Tasks.Day05 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 05==")

    {:ok, input} = File.read("input/day05.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day05.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day05.Part2.solve(input))
  end
end
