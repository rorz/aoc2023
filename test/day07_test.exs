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

  @tag full: true
  test("it solves the full input for part 2") do
    {:ok, full_input} = File.read("input/day07.txt")
    assert Day07.Part2.solve(full_input) == 252_137_472
  end

  test("it correctly replaces jokers with the best card") do
    replace_jokers = &Day07.HandCalculation.replace_jokers_with_best_card/1

    [
      {
        [:joker, :joker, :joker, :joker, :joker],
        [[:joker, :joker, :joker, :joker, :joker]]
      },
      {
        [1, 2, 3, 4, 5],
        [[1], [2], [3], [4], [5]]
      },
      {
        [2, :joker, 2, :joker, 2],
        [[2, 2, 2, 2, 2]]
      },
      {
        [2, :joker, 2, 3, 3],
        [[2, 2, 2], [3, 3]]
      },
      {
        [2, 3, :joker, :joker, :joker],
        [[2, 2, 2, 2], [3]]
      },
      {
        [3, 13, :joker, 7, 2],
        [[2, 2], [3], [7], [13]]
      }
    ]
    |> Enum.each(fn {input, expected} ->
      actual = replace_jokers.(input)
      assert actual == expected
    end)
  end
end
