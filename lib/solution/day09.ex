defmodule Day09.Utils do
  def get_all_difference_lines(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&parse_numbers/1)
    |> Enum.map(&get_difference_lines([&1]))
  end

  defp parse_numbers(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&Utils.to_int/1)
  end

  defp get_difference_lines(difference_lines) do
    difference_line =
      difference_lines
      |> Enum.at(0)
      |> compute_difference_line()
      |> Enum.reverse()

    new_difference_lines = [difference_line | difference_lines]

    if difference_line |> Enum.all?(&is_zero?/1),
      do: new_difference_lines,
      else: get_difference_lines(new_difference_lines)
  end

  def compute_difference_line(line) do
    line
    |> Enum.reduce({nil, []}, fn curr_num, {prev_num, diffs} ->
      {
        curr_num,
        cond do
          !prev_num -> []
          true -> [curr_num - prev_num | diffs]
        end
      }
    end)
    |> elem(1)
  end

  defp is_zero?(num) do
    num == 0
  end
end

defmodule Day09.Part1 do
  def solve(input) do
    input
    |> Day09.Utils.get_all_difference_lines()
    |> Enum.map(
      &Enum.reduce(&1, 0, fn difference_line, acc ->
        [last_num | _] = difference_line |> Enum.reverse()
        acc + last_num
      end)
    )
    |> Enum.sum()
  end
end

defmodule Day09.Part2 do
  def solve(input) do
    input
  end
end

defmodule Mix.Tasks.Day09 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 09==")

    {:ok, input} = File.read("input/day09.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day09.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day09.Part2.solve(input))
  end
end
