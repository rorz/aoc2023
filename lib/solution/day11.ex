defmodule Day11.Utils do
  def solve(input, gap_length) do
    rows =
      input |> to_rows()

    cols =
      rows |> to_columns()

    [empty_row_indices, empty_col_indices] =
      [rows, cols] |> Enum.map(&get_empty_indices/1)

    x_max = last_idx_of_first_row(rows)

    flattened_with_coords =
      rows
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn {char, idx} ->
        {char, get_coords(idx, x_max)}
      end)

    galaxies =
      flattened_with_coords
      |> Enum.filter(fn {char, _} ->
        char == "#"
      end)

    galaxy_coords =
      galaxies
      |> Enum.map(fn {_, coords} ->
        coords
      end)

    get_permutations(galaxy_coords)
    |> Enum.map(fn coords ->
      dist = get_path_dist(coords)

      {x_ext, y_ext} =
        path_ext_lengths(coords, empty_col_indices, empty_row_indices, gap_length)

      dist + x_ext + y_ext
    end)
    |> Enum.sum()
  end

  defp path_ext_lengths([{x_a, y_a}, {x_b, y_b}], x_exts, y_exts, gap) do
    x_m = count_points_between(x_a, x_b, x_exts) * (gap - 1)
    y_m = count_points_between(y_a, y_b, y_exts) * (gap - 1)
    {x_m, y_m}
  end

  defp sort_num(a, b) do
    cond do
      a > b -> {b, a}
      b > a -> {a, b}
      true -> {a, b}
    end
  end

  defp count_points_between(a, b, points) do
    {lower, upper} = sort_num(a, b)

    points
    |> Enum.count(fn point ->
      point > lower and point < upper
    end)
  end

  defp get_path_dist([{x_a, y_a}, {x_b, y_b}]) do
    abs(x_a - x_b) + abs(y_a - y_b)
  end

  defp get_permutations(coords_list) do
    coord_strings = coords_list |> Enum.map(&to_coord_string/1)

    coords_list
    |> Enum.reduce([], fn coord, acc ->
      coord_string = to_coord_string(coord)

      combined_strings =
        coord_strings
        |> Enum.filter(fn c_str ->
          c_str != coord_string
        end)
        |> Enum.map(fn c_str ->
          [c_str, coord_string]
          |> Enum.sort()
          |> Enum.join("_")
        end)

      acc ++ [combined_strings]
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.map(fn comb_str ->
      comb_str
      |> String.split("_")
      |> Enum.map(&from_coord_string/1)
    end)
  end

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
