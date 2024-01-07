defmodule Day12.Part1 do
  def solve(input) do
    lines =
      Utils.split_into_lines(input)
      |> Enum.map(&parse_line/1)

    IO.inspect(lines)
  end

  defp parse_line(line) do
    [record_str, spring_counts_str] = line |> String.split(" ", trim: true)
    record_length = record_str |> String.length()

    spring_counts =
      spring_counts_str |> String.split(",", trim: true) |> Enum.map(&Utils.to_int/1)

    {record_str, record_length, spring_counts}
  end

  defp get_all_permutations_for_line(record_length, spring_counts) do
    allocable_spaces = record_length - Enum.sum(spring_counts)
  end
end

defmodule Day12.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day12 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 12==")

    {:ok, input} = File.read("input/day12.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day12.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day12.Part2.solve(input))
  end
end
