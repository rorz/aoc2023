defmodule Day10.Part1 do
  def solve(input) do
    nil
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
