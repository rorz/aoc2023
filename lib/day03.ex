defmodule Day03.Part1 do
  def solve(input) do
    lines =
      input
      |> Utils.split_into_lines()

    height = length(lines)

    lines_of_chars =
      lines
      |> Enum.map(&String.graphemes/1)

    [first_char_line | _] = lines_of_chars

    width = length(first_char_line)

    lines_of_chars
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn char, idx ->
      {row, col} = get_coords_at_index(idx, width, height)

      {char, row, col}
    end)
  end

  defp get_coords_at_index(index, width, height) do
    # get "row" and "col" values here
  end
end

defmodule Day03.Part2 do
  def solve(input) do
    input
    |> Utils.split_into_lines()
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 03==")

    {:ok, input} = File.read("input/day03.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("*** Part 2 ***")
    IO.puts(Day03.Part2.solve(input))
  end
end
