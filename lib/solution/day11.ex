defmodule Day11.Part1 do
  def solve(input) do
    nil
  end
end

defmodule Day11.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day11 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 11==")

    {:ok, input} = File.read("input/day11.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day11.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day11.Part2.solve(input))
  end
end
