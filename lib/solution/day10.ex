defmodule Day10.Utils do
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

    tiles =
      grid
      |> Enum.reduce([], &(&2 ++ &1))
      |> Enum.with_index()
      |> Enum.map(fn {tile_def, idx} -> tile_def |> Tuple.append(idx) end)

    start_tile =
      tiles
      |> Enum.find(&(&1 |> elem(0) == :start))

    mod_start_tile = {
      infer_tile_type(start_tile, tiles, width, height),
      start_tile |> elem(1),
      start_tile |> elem(2),
      start_tile |> elem(3)
    }

    mod_tiles =
      replace_tile_at(mod_start_tile, tiles)

    {mod_tiles, mod_start_tile, width, height}
  end

  def get_dimensions(lines) do
    {
      length(Enum.at(lines, 1)),
      length(lines)
    }
  end

  defp replace_tile_at(tile, tiles) do
    {_, col, row, _} = tile

    tiles
    |> Enum.map(fn c_tile ->
      {_, c_col, c_row, _} = c_tile

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

  defp get_target_tiles({type, col, row, _}, tiles, col_max, row_max) do
    type
    |> valid_scan_coordinates(col, col_max, row, row_max)
    |> Enum.map(fn {direction, {target_col, target_row}} ->
      target_tile = get_tile(tiles, target_col, target_row)
      {direction, target_tile}
    end)
    |> Enum.filter(fn {direction, {type, _, _, _}} ->
      can_move?(direction, type)
    end)
  end

  def find_path(tiles, tile, col_max, row_max) do
    {type, _, _, _} = tile
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

  defp tiles_same?({_, col_a, row_a, _}, {_, col_b, row_b, _}) do
    col_a == col_b and row_a == row_b
  end

  def get_tile(tiles, col, row) do
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

defmodule Day10.Part1 do
  def solve(input) do
    {tiles, start_tile, col_max, row_max} =
      input
      |> Day10.Utils.parse_grid()

    path =
      tiles
      |> Day10.Utils.find_path(start_tile, col_max, row_max)

    floor((length(path) + 1) / 2)
  end
end

defmodule Day10.Part2 do
  def solve(input) do
    {tiles, start_tile, col_max, row_max} =
      input
      |> Day10.Utils.parse_grid()

    path =
      tiles
      |> Day10.Utils.find_path(start_tile, col_max, row_max)

    enclosed_tiles =
      path |> get_enclosed_tiles(tiles, col_max, row_max)

    IO.inspect(enclosed_tiles)

    length(enclosed_tiles)
    # length(get_enclosed_tiles(path))
  end

  defp get_enclosed_tiles(path, tiles, col_max, row_max) do
    path_indices = path |> Enum.map(&(&1 |> elem(3)))

    path
    |> Enum.reduce([], fn p_tile, e_indices ->
      {p_type, _, _, _} = p_tile

      if p_type in [:vertical, :horizontal] do
        indices =
          p_tile
          |> seek_until_path_idx_or_oob(tiles, path_indices, col_max, row_max)

        (indices ++ e_indices) |> Enum.uniq()
      else
        e_indices
      end
    end)
  end

  defp seek_until_path_idx_or_oob(tile, tiles, path_indices, col_max, row_max) do
    {type, col, row, _} = tile

    col_left = col..1
    col_right = col..col_max
    row_up = row..1
    row_down = row..row_max

    seek_ranges =
      case type do
        :vertical -> [{:col, col_left}, {:col, col_right}]
        :horizontal -> [{:row, row_up}, {:row, row_down}]
        :corner_top_right -> [{:row, row_up}, {:col, col_right}]
        :corner_bottom_right -> [{:row, row_down}, {:col, col_right}]
        :corner_bottom_left -> [{:row, row_down}, {:col, col_left}]
        :corner_top_left -> [{:row, row_up}, {:col, col_left}]
      end

    [seek_a, seek_b] =
      seek_ranges
      |> Enum.map(fn {seek_type, range} ->
        seek_reduce_by(range, seek_type, col, row, tiles, path_indices)
      end)

    if elem(seek_a, 0) == elem(seek_b, 0) do
      []
    else
      {_, result_tiles} =
        [seek_a, seek_b]
        |> Enum.find(&(&1 |> elem(0) == :path))

      result_tiles
    end
  end

  defp seek_reduce_by(range, seek_type, col, row, tiles, path_indices) do
    range
    |> Enum.reduce_while({:first, []}, fn seek, {result, s_tiles} ->
      c_tile =
        case seek_type do
          :col -> Day10.Utils.get_tile(tiles, seek, row)
          :row -> Day10.Utils.get_tile(tiles, col, seek)
        end

      {_, c_col, c_row, c_idx} = c_tile

      cond do
        result != :first and c_idx in path_indices ->
          {:halt, {:path, s_tiles}}

        seek_type == :col and c_col == range.last ->
          {:halt, {:oob, []}}

        seek_type == :row and c_row == range.last ->
          {:halt, {:oob, []}}

        result != :first ->
          {:cont, {:unknown, [c_tile | s_tiles]}}

        result == :first ->
          {:cont, {:unknown, s_tiles}}
      end
    end)
  end

  def within_path?(x, y, path) do
    limit = length(path) - 1

    {result, _} =
      0..limit
      |> Enum.reduce_while(
        {false, limit - 1},
        fn idx, {in_path, last_idx} ->
          {path_x, path_y} = path |> Enum.at(idx)
          {prev_path_x, prev_path_y} = path |> Enum.at(last_idx)

          cond do
            x == path_x and y == path_y ->
              {:halt, {:corner, idx}}

            path_y > y != prev_path_y > y ->
              slope = get_slope(x, path_x, prev_path_x, y, path_y, prev_path_y)

              cond do
                slope == 0 ->
                  {:halt, {:on_line, idx}}

                slope < 0 != prev_path_y < path_y ->
                  {:cont, {!in_path, idx}}

                true ->
                  {:cont, {in_path, idx}}
              end

            true ->
              {:cont, {in_path, idx}}
          end
        end
      )

    result
  end

  defp get_slope(x, path_x, prev_path_x, y, path_y, prev_path_y) do
    (x - path_x) * (prev_path_y - path_y) -
      (y - path_y) * (prev_path_x - path_x)
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
