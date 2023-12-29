defmodule Day07Test do
  use ExUnit.Case

  @example """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  @tag example: true
  test("it solves the example input for part 1") do
    assert Day07.Part1.solve(@example) == 6440
  end

  @tag example: true
  test("it solves the example input for part 2") do
    assert Day07.Part2.solve(@example) == 5905
  end
end
