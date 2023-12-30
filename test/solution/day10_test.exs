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

  @example_enclosed_1 """
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  """

  @example_enclosed_2 """
  ..........
  .S------7.
  .|F----7|.
  .||....||.
  .||....||.
  .|L-7F-J|.
  .|..||..|.
  .L--JL--J.
  ..........
  """

  @example_enclosed_3 """
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
  """

  @example_enclosed_4 """
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  """

  @tag example: true
  test "solves the first example input for part 2" do
    assert Part2.solve(@example_enclosed_1) == 4
  end

  @tag example: true
  test "solves the second example input for part 2" do
    assert Part2.solve(@example_enclosed_2) == 4
  end

  @tag example: true
  test "solves the third example input for part 2" do
    assert Part2.solve(@example_enclosed_3) == 8
  end

  @tag example: true
  test "solves the fourth example input for part 2" do
    assert Part2.solve(@example_enclosed_4) == 10
  end

  test "determines if point is in path" do
    path = [
      {2, 2},
      {4, 2},
      {4, 4},
      {2, 4},
      {2, 2}
    ]

    [
      {false, {0, 0}},
      {:corner, {2, 2}},
      {:on_line, {2, 3}},
      {true, {3, 3}},
      {false, {8, 8}}
    ]
    |> Enum.each(fn {expected, coords} ->
      actual = coords |> Part2.is_within_path(path)
      assert expected == actual
    end)
  end

  test "determines if the point is in complex path" do
    looks_like = """
    -------
    XXXXX--
    XXX0X--
    XXX0X--
    XXXXX--
    """

    path = [
      {1, 1},
      {2, 1},
      {3, 1},
      {4, 1},
      {5, 1},
      {5, 2},
      {5, 3},
      {5, 4},
      {4, 4},
      {3, 4},
      {2, 4},
      {1, 4},
      {1, 3},
      {2, 3},
      {3, 3},
      {3, 2},
      {2, 2},
      {1, 2},
      {1, 1}
    ]

    [
      {false, {8, 8}},
      {true, {4, 2}},
      {true, {4, 3}},
      {:corner, {1, 2}}
    ]
    |> Enum.each(fn {expected, coords} ->
      actual = coords |> Part2.is_within_path(path)
      assert expected == actual
    end)
  end
end
