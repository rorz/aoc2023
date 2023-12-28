defmodule Day05.Part1 do
  def solve(input) do
    [seeds_line | lines] =
      input
      |> String.split("\n", trim: true)

    [_, seed_numbers_str] =
      seeds_line
      |> String.split(":")

    seeds =
      seed_numbers_str
      |> String.split(" ", trim: true)

    maps =
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

    seeds
    |> Enum.map(fn seed_str ->
      {seed, _} = Integer.parse(seed_str)

      seed
      |> get_computed_value_for("seed", maps)
    end)
    |> Enum.min()
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

  defp get_computed_value_for(value, type, maps) do
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
            get_computed_value_for(new_value, dest, maps)

          _ ->
            get_computed_value_for(value, dest, maps)
        end
    end
  end
end

defmodule Day05.Part2 do
  def solve(input) do
    nil
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
