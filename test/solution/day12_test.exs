defmodule Day12Test do
  use ExUnit.Case

  alias Day12.Part1, as: Part1
  alias Day12.Part2, as: Part2

  @example """
  #.#.### 1,1,3
  .#...#....###. 1,1,3
  .#.###.#.###### 1,3,1,6
  ####.#...#... 4,1,1
  #....######..#####. 1,6,5
  .###.##....# 3,2,1
  """

  @tag example: true
  test "solves the example input for part 1" do
    assert Part1.solve(@example) == 21
  end

  @tag :skip
  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example) == nil
  end
end
