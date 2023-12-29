defmodule Day08Test do
  use ExUnit.Case

  alias Day08.Part1, as: Part1
  alias Day08.Part2, as: Part2

  @example_part1_1 """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @example_part1_2 """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @tag example: true
  test "solves the first example input for part 1" do
    assert Part1.solve(@example_part1_1) == 2
  end

  @tag example: true
  test "solves the second example input for part 1" do
    assert Part1.solve(@example_part1_2) == 6
  end

  @example_part2 """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example_part2) == 6
  end
end
