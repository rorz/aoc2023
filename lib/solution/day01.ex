defmodule Day01.Utils do
  def process_lines(input, process_line_function) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(process_line_function)
    |> Enum.map(&get_first_and_last_numbers/1)
    |> join_and_sum()
  end

  def get_first_and_last_numbers(input) do
    [first_number | rest] = input

    case length(rest) do
      0 ->
        [first_number, first_number]

      _ ->
        [last_number | _] = Enum.reverse(rest)
        [first_number, last_number]
    end
  end

  def join_and_sum(lists_of_chars) do
    lists_of_chars
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&elem(Integer.parse(&1), 0))
    |> Enum.sum()
  end
end

defmodule Day01.Part1 do
  def solve(input) do
    Day01.Utils.process_lines(input, &get_numbers_from_string/1)
  end

  def is_valid_number(string) do
    case Integer.parse(string) do
      {_, ""} -> true
      _ -> false
    end
  end

  def get_numbers_from_string(input) do
    input
    |> String.graphemes()
    |> Enum.filter(&is_valid_number/1)
  end
end

defmodule Day01.Part2 do
  @numbers [
    {"one", 1},
    {"two", 2},
    {"three", 3},
    {"four", 4},
    {"five", 5},
    {"six", 6},
    {"seven", 7},
    {"eight", 8},
    {"nine", 9}
  ]

  def solve(input) do
    Day01.Utils.process_lines(input, &get_numbers_from_string/1)
  end

  def get_numbers_from_string(input) do
    input
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce([], fn {char, idx}, acc ->
      case Integer.parse(char) do
        {number, _} ->
          acc ++ [number]

        # not a number
        :error ->
          Enum.reduce(@numbers, acc, fn {word, number}, inner_acc ->
            # Use String.slice to get a substring equal to the length of the word
            if idx + String.length(word) <= String.length(input) and
                 String.slice(input, idx, String.length(word)) == word do
              inner_acc ++ [number]
            else
              inner_acc
            end
          end)
      end
    end)
  end
end

defmodule Mix.Tasks.Day01 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 01==")

    {:ok, input} = File.read("input/day01.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day01.Part1.solve(input))
    IO.puts("*** Part 2 ***")
    IO.puts(Day01.Part2.solve(input))
  end
end
