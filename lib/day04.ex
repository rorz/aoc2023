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
      length -> {:winner, length}
    end
  end

  defp get_card_number("Card " <> num), do: num

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
        {:winner, num_matches} -> Integer.pow(2, num_matches - 1)
      end
    end)
    |> Enum.sum()
  end
end

defmodule Day04.Part2 do
  def solve(input) do
    nil
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
