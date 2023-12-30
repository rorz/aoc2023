defmodule Day10.Utils do
  def parse_grid(input) do
    grid =
      input
      |> Utils.split_into_lines()
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.map(fn {line, row_idx} ->
        line
        |> Enum.with_index()
        |> Enum.map(fn {char, col_idx} ->
          type =
            case char do
              "|" -> :vertical
              "-" -> :horizontal
              "7" -> :corner_top_right
              "J" -> :corner_bottom_right
              "L" -> :corner_bottom_left
              "F" -> :corner_top_left
              "S" -> :start
              "." -> :space
            end

          {type, row_idx + 1, col_idx + 1}
        end)
      end)

    {width, height} = grid |> get_dimensions()
    flat_grid = grid |> Enum.reduce([], &(&2 ++ &1))

    {flat_grid, width, height}
  end

  def get_dimensions(lines) do
    {
      length(Enum.at(lines, 1)),
      length(lines)
    }
  end
end

defmodule Day10.Part1 do
  def solve(input) do
    grid = Day10.Utils.parse_grid(input)
    IO.inspect(grid)
  end
end

defmodule Day10.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day10 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 10==")

    {:ok, input} = File.read("input/day10.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day10.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day10.Part2.solve(input))
  end
end
