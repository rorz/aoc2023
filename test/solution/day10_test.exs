defmodule Day10Test do
  use ExUnit.Case

  alias Day10.Part1, as: Part1
  alias Day10.Part2, as: Part2

  @example_simple_loop """
  -L|F7
  7S-7|
  L|7||
  -L-J|
  L|-JF
  """

  @example_complex_loop """
  7-F7-
  .FJ|7
  SJLL7
  |F--J
  LJ.LJ
  """

  @tag example: true
  test "solves the example simple loop input for part 1" do
    assert Part1.solve(@example) == 4
  end

  @tag example: true
  test "solves the example complex loop input for part 1" do
    assert Part1.solve(@example) == 8
  end

  @tag :skip
  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example) == nil
  end
end
