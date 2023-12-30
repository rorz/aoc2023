defmodule Day11Test do
  use ExUnit.Case

  alias Day11.Part1, as: Part1
  alias Day11.Part2, as: Part2

  @example """
  EXAMPLE_INPUT_HERE
  """

  @tag :skip
  @tag example: true
  test "solves the example input for part 1" do
    assert Part1.solve(@example) == nil
  end

  @tag :skip
  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example) == nil
  end
end
