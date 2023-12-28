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

    source_end = source_start + (length - 1)
    offset = dest_start - source_start

    {source_start..source_end, offset}
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
          |> Enum.find(fn {range, _} ->
            value in range
          end)
        ) do
          {_, offset} ->
            new_value = value + offset
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

    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] -> start..(start + (length - 1)) end)

    # seed_to_soil_ranges =
    #   maps["seed"].ranges
    #   |> Enum.map(fn {source_start, _, length} ->
    #     source_start..(source_start + length)
    #   end)

    # seeds
    # |> convert_seed_ranges_to_list(seed_to_soil_ranges)
    # |> Enum.map(fn value ->
    #   Day05.Utils.get_computed_value_for(value, maps)
    # end)
    # |> Enum.min()

    # IO.inspect(seed_ranges)

    computed_ranges =
      seed_ranges
      # |> Enum.map(&get_computed_ranges_for(&1, maps))
      |> Enum.map(fn seed_range ->
        IO.puts("Doing a seed range!")

        computed_ranges =
          get_computed_ranges_for(seed_range, maps)

        # |> List.flatten()

        computed_ranges
      end)
      |> List.flatten()

    IO.inspect(computed_ranges, limit: :infinity)

    computed_ranges
    |> List.flatten()
    |> Enum.map(fn range ->
      range.first
    end)
    |> Enum.min()
  end

  def get_computed_ranges_for(range, maps) do
    get_computed_ranges_for([range], maps, "seed")
  end

  def get_computed_ranges_for(ranges, maps, type) do
    case maps[type] do
      nil ->
        ranges

      %{dest: next_type, ranges: mapping_ranges} ->
        new_ranges =
          ranges
          |> Enum.map(fn range ->
            mapping_ranges
            |> Enum.map(fn {mapping_range, offset} ->
              intersect_and_split(range, mapping_range, offset)
            end)
          end)
          |> List.flatten()
          |> Enum.dedup()

        get_computed_ranges_for(new_ranges, maps, next_type)
    end
  end

  def intersect_and_split(source_range, target_range, offset_when_match) do
    case get_range_intersect(source_range, target_range) do
      :no_intersect ->
        [source_range]

      intersect_range ->
        [
          case source_range.first < target_range.first do
            true -> source_range.first..target_range.first
            false -> nil
          end,
          case source_range.last > target_range.last do
            true -> target_range.last..source_range.last
            false -> nil
          end,
          Range.shift(intersect_range, offset_when_match)
        ]
        |> Enum.filter(fn el -> el != nil end)
    end
  end

  def get_range_intersect(source_range, target_range) do
    case Range.disjoint?(source_range, target_range) do
      true ->
        :no_intersect

      false ->
        output_start = max(source_range.first, target_range.first)
        output_end = min(source_range.last, target_range.last)
        output_start..output_end
    end
  end

  def get_first_and_last_for_range(range) do
    {range.first, range.last}
  end

  defp get_lowest_value(ranges, mapping_ranges) do
    unaffected_ranges =
      ranges
      |> Enum.map(fn range ->
        mapping_ranges
        |> Enum.filter(fn {mapping_range, _} ->
          range |> Range.disjoint?(mapping_range)
        end)
      end)

    #
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
