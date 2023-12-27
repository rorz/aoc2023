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

  # test("solves the example input for part 2") do
  #   assert Day03.Part2.solve(@example) == 0
  # end
end
