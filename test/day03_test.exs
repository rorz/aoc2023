defmodule Day03Test do
  use ExUnit.Case

  @example """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test("solves the example input for part 1") do
    assert Day03.Part1.solve(@example) == 4361
  end

  @tag full: true
  test("solves the full input for part 1") do
    {:ok, input} = File.read("input/day03.txt")
    assert Day03.Part1.solve(input) == 521_515
  end

  test("solves the example input for part 2") do
    assert Day03.Part2.solve(@example) == 467_835
  end

  @tag full: true
  test("solves the full input for part 2") do
    {:ok, input} = File.read("input/day03.txt")
    assert Day03.Part2.solve(input) == 69_527_306
  end
end
