defmodule Day07.Part1 do
  def solve(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&parse_hand_line/1)
    |> sort()
    |> Enum.reverse()
    |> compute_bid_values()
    |> Enum.sum()
  end

  defp parse_hand_line(line) do
    [hand_str, bid_str] = String.split(line, " ", trim: true)

    cards = convert_hand_to_card_nums(hand_str)
    hand = get_hand_type(cards)
    bid = Utils.to_int(bid_str)

    {cards, hand, bid}
  end

  defp sort_by_hand_rank({_, hand_a, _}, {_, hand_b, _}) do
    get_hand_rank(hand_a) >= get_hand_rank(hand_b)
  end

  defp sort_by_inner_group(hands) do
    hands
    |> Enum.chunk_by(fn {_, hand, _} -> hand end)
    |> Enum.flat_map(fn group ->
      group
      |> Enum.sort(fn {cards_a, _, _}, {cards_b, _, _} ->
        cards_a >= cards_b
      end)
    end)
  end

  defp sort(hands) do
    hands
    |> Enum.sort(&sort_by_hand_rank/2)
    |> sort_by_inner_group()
  end

  defp compute_bid_values(hands) do
    hands
    |> Enum.map(fn {_, _, bid} -> bid end)
    |> Enum.with_index(1)
    |> Enum.map(fn {index, bid} -> index * bid end)
  end

  defp convert_hand_to_card_nums(hand_str) do
    hand_str
    |> String.graphemes()
    |> Enum.map(fn card_str ->
      case card_str do
        "A" ->
          14

        "K" ->
          13

        "Q" ->
          12

        "J" ->
          11

        "T" ->
          10

        num_str ->
          Utils.to_int(num_str)
      end
    end)
  end

  defp get_hand_type(cards) do
    cards_by_value =
      cards
      |> Enum.sort()
      |> Enum.chunk_by(& &1)

    case length(cards_by_value) do
      1 ->
        :five_of_a_kind

      2 ->
        if cards_by_value |> inner_group_has_length(4) do
          :four_of_a_kind
        else
          :full_house
        end

      3 ->
        if cards_by_value |> inner_group_has_length(3) do
          :three_of_a_kind
        else
          :two_pair
        end

      4 ->
        :one_pair

      5 ->
        :high_card
    end
  end

  defp get_hand_rank(hand_type) do
    case hand_type do
      :high_card -> 0
      :one_pair -> 1
      :two_pair -> 2
      :three_of_a_kind -> 3
      :full_house -> 4
      :four_of_a_kind -> 5
      :five_of_a_kind -> 6
    end
  end

  defp inner_group_has_length(list, length) do
    list |> Enum.any?(fn group -> length(group) == length end)
  end
end

defmodule Day07.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day07 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 07==")

    {:ok, input} = File.read("input/day07.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day07.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day07.Part2.solve(input))
  end
end
