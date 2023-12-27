defmodule Day04.Utils do
  def get_game_line(line) do
    [card_num_str, numbers] =
      line
      |> String.split(":")
      |> Enum.map(&String.trim/1)

    card_number = get_card_number(card_num_str)

    [my_numbers, winning_numbers] =
      numbers
      |> String.split("|")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&break_into_digits/1)

    {card_number, my_numbers, winning_numbers}
  end

  def get_matches({my_numbers, winning_numbers}) do
    matches =
      my_numbers
      |> Enum.filter(fn num -> num in winning_numbers end)

    case length(matches) do
      0 -> :not_winner
      length -> length
    end
  end

  defp get_card_number("Card " <> num), do: num |> String.trim()

  defp break_into_digits(number_line) do
    number_line
    |> String.split(" ", trim: true)
    |> Enum.map(&String.trim/1)
  end
end

defmodule Day04.Part1 do
  def solve(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&Day04.Utils.get_game_line/1)
    |> Enum.map(fn {_, my_numbers, winning_numbers} ->
      case Day04.Utils.get_matches({my_numbers, winning_numbers}) do
        :not_winner -> 0
        num_matches -> Integer.pow(2, num_matches - 1)
      end
    end)
    |> Enum.sum()
  end
end

defmodule Day04.Part2 do
  def solve(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&Day04.Utils.get_game_line/1)
    |> Enum.map(fn {card_number, my_numbers, winning_numbers} ->
      [card_number, Day04.Utils.get_matches({my_numbers, winning_numbers})]
    end)
    |> Enum.reduce(%{}, fn [card_number_str, matches], acc ->
      {card_number, _} = Integer.parse(card_number_str)

      card_count =
        case acc |> Map.get(card_number) do
          nil -> 1
          count -> count + 1
        end

      new_acc = acc |> Map.put(card_number, card_count)

      case matches do
        :not_winner ->
          new_acc

        num_matches ->
          next_card_number = card_number + 1

          next_card_number..(card_number + num_matches)
          |> Enum.reduce(new_acc, fn target_card_number, inner_acc ->
            case Map.get(inner_acc, target_card_number) do
              nil ->
                Map.put(inner_acc, target_card_number, card_count)

              existing_num ->
                Map.put(
                  inner_acc,
                  target_card_number,
                  existing_num + card_count
                )
            end
          end)
      end
    end)
    |> Map.values()
    |> Enum.sum()
  end
end

defmodule Mix.Tasks.Day04 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 04==")

    {:ok, input} = File.read("input/day04.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day04.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day04.Part2.solve(input))
  end
end
