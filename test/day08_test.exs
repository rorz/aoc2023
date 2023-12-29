defmodule Day08Test do
  use ExUnit.Case

  @example_first """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @example_second """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @tag example: true
  test "solves the first example input for part 1" do
    assert Day08.Part1.solve(@example_first) == 2
  end

  @tag example: true
  test "solves the second example input for part 1" do
    assert Day08.Part2.solve(@example_second) == 6
  end
end
