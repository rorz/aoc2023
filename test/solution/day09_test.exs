defmodule Day09Test do
  use ExUnit.Case

  alias Day09.Part1, as: Part1
  alias Day09.Part2, as: Part2

  @example """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  @tag example: true
  test "solves the example input for part 1" do
    assert Part1.solve(@example) == 114
  end

  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example) == 5
  end
end
