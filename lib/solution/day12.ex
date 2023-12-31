defmodule Day12.Part1 do
  def solve(input) do
    nil
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
