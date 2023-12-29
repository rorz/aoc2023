defmodule Day09.Part1 do
  def solve(input) do
    nil
  end
end

defmodule Day09.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day09 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 09==")

    {:ok, input} = File.read("input/day09.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day09.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day09.Part2.solve(input))
  end
end
