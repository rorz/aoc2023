defmodule Day08.Part1 do
  def solve(input) do
    nil
  end
end

defmodule Day08.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 08==")

    {:ok, input} = File.read("input/day08.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day08.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day07.Part2.solve(input))
  end
end
