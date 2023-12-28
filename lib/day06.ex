defmodule Day06.Part1 do
  def solve(input) do
    nil
  end
end

defmodule Day06.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 06==")

    {:ok, input} = File.read("input/day06.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day06.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day06.Part2.solve(input))
  end
end
