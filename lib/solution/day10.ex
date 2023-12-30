defmodule Day10.Utils do
  def parse_grid(input) do
    grid =
      input
      |> Utils.split_into_lines()
      |> Enum.map(&String.graphemes/1)
      |> Enum.with_index()
      |> Enum.map(fn {line, row_idx} ->
        line
        |> Enum.with_index()
        |> Enum.map(fn {char, col_idx} ->
          type =
            case char do
              "|" -> :vertical
              "-" -> :horizontal
              "7" -> :corner_top_right
              "J" -> :corner_bottom_right
              "L" -> :corner_bottom_left
              "F" -> :corner_top_left
              "S" -> :start
              "." -> :space
            end

          {type, col_idx + 1, row_idx + 1}
        end)
      end)

    {width, height} = grid |> get_dimensions()
    flat_grid = grid |> Enum.reduce([], &(&2 ++ &1))

    {flat_grid, width, height}
  end

  def get_dimensions(lines) do
    {
      length(Enum.at(lines, 1)),
      length(lines)
    }
  end
end

defmodule Day10.Part1 do
  @tile_types [
    :vertical,
    :horizontal,
    :corner_top_right,
    :corner_bottom_right,
    :corner_bottom_left,
    :corner_top_left,
    :start,
    :space
  ]

  def solve(input) do
    {tiles, col_max, row_max} = Day10.Utils.parse_grid(input)

    start_tile =
      tiles
      |> Enum.find(&(&1 |> elem(0) == :start))

    mod_start_tile = {
      infer_tile_type(start_tile, tiles, col_max, row_max),
      start_tile |> elem(1),
      start_tile |> elem(2)
    }

    mod_tiles = replace_tile_at(mod_start_tile, tiles)

    path = find_path(mod_start_tile, mod_tiles, col_max, row_max)
    floor((length(path) + 1) / 2)
  end

  defp replace_tile_at(tile, tiles) do
    {_, col, row} = tile

    tiles
    |> Enum.map(fn c_tile ->
      {_, c_col, c_row} = c_tile

      if c_col == col and c_row == row do
        tile
      else
        c_tile
      end
    end)
  end

  defp infer_tile_type(tile, tiles, col_max, row_max) do
    target_directions =
      tile
      |> get_target_tiles(tiles, col_max, row_max)
      |> Enum.map(fn {direction, _} -> direction end)

    Enum.find(@tile_types, fn type ->
      Enum.sort(target_directions) == Enum.sort(possible_move_types(type))
    end)
  end

  defp get_target_tiles({type, col, row}, tiles, col_max, row_max) do
    type
    |> valid_scan_coordinates(col, col_max, row, row_max)
    |> Enum.map(fn {direction, {target_col, target_row}} ->
      target_tile = get_tile(tiles, target_col, target_row)
      {direction, target_tile}
    end)
    |> Enum.filter(fn {direction, {type, _, _}} ->
      can_move?(direction, type)
    end)
  end

  defp find_path(tile, tiles, col_max, row_max) do
    {type, _, _} = tile
    [random_direction | _] = type |> possible_move_types()
    find_path([tile], random_direction, tile, tiles, col_max, row_max)
  end

  defp find_path(path, going, end_tile, tiles, col_max, row_max) do
    [current_tile | _] = path

    [{_, target_tile}] =
      current_tile
      |> get_target_tiles(tiles, col_max, row_max)
      |> Enum.filter(fn {on_the, _} ->
        going == on_the
      end)

    if tiles_same?(target_tile, end_tile) do
      path
    else
      [to] =
        target_tile
        |> elem(0)
        |> possible_move_types()
        |> Enum.filter(fn type ->
          type != get_join_direction(going)
        end)

      find_path(
        [target_tile | path],
        to,
        end_tile,
        tiles,
        col_max,
        row_max
      )
    end
  end

  defp tiles_same?({type_a, col_a, row_a}, {type_b, col_b, row_b}) do
    type_a == type_b and col_a == col_b and row_a == row_b
  end

  defp get_tile(tiles, col, row) do
    tiles |> Enum.find(&(&1 |> elem(1) == col and &1 |> elem(2) == row))
  end

  defp can_move?(direction, target_type) do
    possible_moves =
      target_type
      |> possible_move_types()

    possible_moves
    |> Enum.map(&get_join_direction/1)
    |> Enum.any?(&(&1 == direction))
  end

  def valid_scan_coordinates(type, col, col_max, row, row_max) do
    type
    |> possible_move_types()
    |> Enum.map(
      &case &1 do
        :up -> {&1, {col, row - 1}}
        :right -> {&1, {col + 1, row}}
        :down -> {&1, {col, row + 1}}
        :left -> {&1, {col - 1, row}}
      end
    )
    |> Enum.filter(&coordinates_valid?(&1 |> elem(1), col_max, row_max))
  end

  defp get_join_direction(direction) do
    case direction do
      :up -> :down
      :right -> :left
      :down -> :up
      :left -> :right
    end
  end

  defp coordinates_valid?({col, row}, col_max, row_max) do
    col_valid? = col > 0 and col <= col_max
    row_valid? = row > 0 and row <= row_max
    col_valid? and row_valid?
  end

  defp possible_move_types(type) do
    case type do
      :vertical -> [:up, :down]
      :horizontal -> [:left, :right]
      :corner_top_right -> [:left, :down]
      :corner_bottom_right -> [:left, :up]
      :corner_bottom_left -> [:right, :up]
      :corner_top_left -> [:right, :down]
      :start -> [:up, :right, :down, :left]
      :space -> []
    end
  end
end

defmodule Day10.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day10 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 10==")

    {:ok, input} = File.read("input/day10.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day10.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day10.Part2.solve(input))
  end
end
