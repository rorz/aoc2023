defmodule Day10Test do
  use ExUnit.Case

  alias Day10.Part1, as: Part1
  alias Day10.Part2, as: Part2
  alias Day10.Utils, as: Utils

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
    assert Part1.solve(@example_simple_loop) == 4
  end

  @tag example: true
  test "solves the example complex loop input for part 1" do
    assert Part1.solve(@example_complex_loop) == 8
  end

  test "gets valid scan coordinates for example values" do
    row_max = 4
    col_max = 4

    cases = [
      {
        {:vertical, 2, 2},
        [up: {2, 1}, down: {2, 3}]
      },
      {
        {:vertical, 1, 1},
        [down: {1, 2}]
      },
      {
        {:horizontal, 2, 2},
        [left: {1, 2}, right: {3, 2}]
      },
      {
        {:horizontal, 4, 1},
        [left: {3, 1}]
      },
      {
        {:corner_bottom_right, 4, 4},
        [up: {4, 3}, left: {3, 4}]
      }
    ]

    Enum.each(cases, fn {{type, col, row}, expected} ->
      actual = Utils.valid_scan_coordinates(type, col, col_max, row, row_max)
      assert Enum.sort(expected) == Enum.sort(actual)
    end)
  end

  @tag :skip
  @tag example: true
  test "solves the example input for part 2" do
    assert Part2.solve(@example) == nil
  end
end
