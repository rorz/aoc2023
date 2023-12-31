defmodule Day11.Utils do
  def solve(input, gap_length) do
    rows = input |> to_rows()
    {x_max, empty_x, empty_y} = parse_rows(rows)

    rows
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.reduce([], &get_char_coords(&1, &2, x_max))
    |> get_permutations()
    |> Enum.map(&(get_path_dist(&1) + path_ext(&1, empty_x, empty_y, gap_length)))
    |> Enum.sum()
  end

  defp get_char_coords({char, idx}, acc, x_max),
    do: if(char == "#", do: [get_coords(idx, x_max) | acc], else: acc)

  defp parse_rows(rows),
    do: {
      last_idx_of_first_row(rows),
      get_empty_indices(rows |> to_columns()),
      get_empty_indices(rows)
    }

  defp path_ext([{x_a, y_a}, {x_b, y_b}], x_exts, y_exts, gap),
    do:
      count_points_between(x_a, x_b, x_exts) * (gap - 1) +
        count_points_between(y_a, y_b, y_exts) * (gap - 1)

  defp count_points_between(a, b, points) do
    [lower, upper] = Enum.sort([a, b])

    points
    |> Enum.count(fn point ->
      point > lower and point < upper
    end)
  end

  defp get_path_dist([{x_a, y_a}, {x_b, y_b}]),
    do: abs(x_a - x_b) + abs(y_a - y_b)

  defp get_permutations(coords_list),
    do:
      coords_list
      |> Enum.reduce(
        [],
        &permute(
          &1,
          &2,
          coords_list
          |> Enum.map(fn coord ->
            to_coord_string(coord)
          end)
        )
      )
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.map(fn comb_str ->
        comb_str
        |> String.split("_")
        |> Enum.map(&from_coord_string/1)
      end)

  defp permute(coord, acc, coord_strings),
    do:
      acc ++
        [
          coord_strings
          |> Enum.filter(fn c_str ->
            c_str != to_coord_string(coord)
          end)
          |> Enum.map(fn c_str ->
            [c_str, to_coord_string(coord)]
            |> Enum.sort()
            |> Enum.join("_")
          end)
        ]

  defp to_coord_string({x, y}), do: "#{x}-#{y}"

  defp from_coord_string(str),
    do: str |> String.split("-") |> Enum.map(&Utils.to_int/1) |> List.to_tuple()

  defp get_coords(idx, x_max),
    do: {
      rem(idx, x_max + 1),
      floor(idx / (x_max + 1))
    }

  defp get_empty_indices(dim),
    do:
      dim
      |> Enum.with_index()
      |> Enum.filter(&(&1 |> elem(0) |> lacks?("#")))
      |> Enum.map(&(&1 |> elem(1)))

  defp lacks?(list, char), do: list |> Enum.all?(&(&1 != char))

  defp to_rows(input),
    do:
      input
      |> Utils.split_into_lines()
      |> Enum.map(&String.graphemes/1)

  defp to_columns(rows),
    do:
      0..last_idx_of_first_row(rows)
      |> Enum.map(&get_at_col(&1, rows))

  defp get_at_col(idx, rows), do: rows |> Enum.map(&Enum.at(&1, idx))
  defp last_idx_of_first_row(rows), do: length(rows |> List.first()) - 1
end

defmodule Day11.Part1 do
  def solve(input) do
    Day11.Utils.solve(input, 2)
  end
end

defmodule Day11.Part2 do
  def solve(input) do
    Day11.Utils.solve(input, 1_000_000)
  end
end

defmodule Mix.Tasks.Day11 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 11==")

    {:ok, input} = File.read("input/day11.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day11.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day11.Part2.solve(input))
  end
end
