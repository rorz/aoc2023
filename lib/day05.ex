defmodule Day05.Part1 do
  def solve(input) do
    nil
  end
end

defmodule Day05.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 04==")

    {:ok, input} = File.read("input/day04.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day04.Part2.solve(input))
  end
end
