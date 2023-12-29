defmodule Day06Test do
  use ExUnit.Case

  @example """
  Time:      7  15   30
  Distance:  9  40  200
  """

  @tag example: true
  test("solves the example input for part 1") do
    assert Day06.Part1.solve(@example) == 288
  end

  @tag example: true
  test("solves the example input for part 2") do
    assert Day06.Part2.solve(@example) == 71503
  end
end
