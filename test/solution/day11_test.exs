defmodule Day11Test do
  use ExUnit.Case

  alias Day11.Utils, as: Utils

  @example """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  @tag example: true
  test "solves the example input with a gap length of 2" do
    assert Utils.solve(@example, 2) == 374
  end

  @tag example: true
  test "solves the example input with a gap length of 10" do
    assert Utils.solve(@example, 10) == 1030
  end

  @tag example: true
  test "solves the example input with a gap length of 100" do
    assert Utils.solve(@example, 100) == 8410
  end
end
