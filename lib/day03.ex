defmodule Day03.Utils do
  def get_coords_at_idx(idx, width, height) do
    row = floor(idx / height)
    col = rem(idx, width)
    {row, col}
  end

  def get_idx_for_coords(row, col, height) do
    row * height + col
  end

  def get_adjacent_coords(row, col, height, width) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.filter(fn {row, col} ->
      row >= 0 && row < height && col >= 0 && col < width
    end)
  end

  def get_size_of_matrix(lines) do
    height = length(lines)
    [first_line | _] = lines
    width = length(first_line)
    {width, height}
  end

  def get_lines_of_chars(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&String.graphemes/1)
  end
end

defmodule Day03.Part1 do
  def solve(input) do
    lines_of_chars =
      input
      |> Day03.Utils.get_lines_of_chars()

    {width, height} = Day03.Utils.get_size_of_matrix(lines_of_chars)

    %{affected: affected, numbers: numbers} =
      lines_of_chars
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn {char, idx} ->
        {row, col} = Day03.Utils.get_coords_at_idx(idx, width, height)
        char_type = get_type_of_char(char)
        {char, char_type, row, col, idx}
      end)
      |> Enum.reduce(
        %{affected: [], numbers: []},
        fn {
             char,
             char_type,
             row,
             col,
             idx
           },
           acc ->
          case char_type do
            :space ->
              acc

            :number ->
              Map.put(acc, :numbers, acc.numbers ++ [{char, idx}])

            :special ->
              adjacent_indices =
                Day03.Utils.get_adjacent_coords(row, col, height, width)
                |> Enum.map(fn {row, col} ->
                  Day03.Utils.get_idx_for_coords(row, col, height)
                end)

              affected =
                (adjacent_indices ++ acc.affected)
                |> Enum.sort()
                |> Enum.dedup()

              Map.put(acc, :affected, affected)
          end
        end
      )

    number_results =
      numbers
      |> Enum.reduce(
        %{
          numbers: [],
          last_idx: -1,
          current_number: "",
          current_indices: []
        },
        fn {char, idx}, acc ->
          current_row = div(idx, width)
          last_row = div(acc.last_idx, width)

          case acc.last_idx do
            _ when idx == acc.last_idx + 1 and current_row == last_row ->
              acc
              |> Map.put(:last_idx, idx)
              |> Map.put(:current_number, acc.current_number <> char)
              |> Map.put(:current_indices, acc.current_indices ++ [idx])

            _ ->
              # Starting a new number
              new_acc =
                if acc.current_number != "" do
                  # Append the completed number and its indices to acc.numbers
                  Map.put(
                    acc,
                    :numbers,
                    acc.numbers ++ [{acc.current_number, acc.current_indices}]
                  )
                else
                  acc
                end

              new_acc
              |> Map.put(:last_idx, idx)
              |> Map.put(:current_number, char)
              |> Map.put(:current_indices, [idx])
          end
        end
      )
      |> (fn acc ->
            # Append the last number if it exists
            if acc.current_number != "" do
              Map.update!(acc, :numbers, fn numbers ->
                numbers ++ [{acc.current_number, acc.current_indices}]
              end)
            else
              acc
            end
          end).()

    extract_affected_numbers(number_results.numbers, affected)
    |> Enum.sum()
  end

  defp get_type_of_char("."), do: :space

  defp get_type_of_char(char) do
    case Integer.parse(char) do
      {_, _} -> :number
      _ -> :special
    end
  end

  defp extract_affected_numbers(number_pairs, affected_indices) do
    number_pairs
    |> Enum.filter(fn {_, indices} ->
      indices
      |> Enum.any?(fn idx -> idx in affected_indices end)
    end)
    |> Enum.map(fn {number, _} -> number end)
    |> Enum.map(fn number_str ->
      case Integer.parse(number_str) do
        {number, _} -> number
        :error -> :error
      end
    end)
  end
end

defmodule Day03.Part2 do
  def solve(input) do
    lines_of_chars =
      input
      |> Day03.Utils.get_lines_of_chars()

    {width, height} =
      lines_of_chars
      |> Day03.Utils.get_size_of_matrix()

    %{gears: gears, num_chars: num_chars} =
      lines_of_chars
      |> get_flattened_with_index()
      |> with_metadata(width, height)
      |> Enum.reduce(
        %{gears: [], num_chars: []},
        fn {char, char_type, row, col, idx}, acc ->
          case char_type do
            :gear ->
              acc
              |> Map.put(:gears, acc.gears ++ [{row, col}])

            :number ->
              acc
              |> Map.put(:num_chars, acc.num_chars ++ [{char, col, idx}])

            _ ->
              acc
          end
        end
      )

    affected_indices =
      gears
      |> Enum.map(fn {row, col} ->
        Day03.Utils.get_adjacent_coords(row, col, height, width)
        |> Enum.map(fn {adj_row, adj_col} ->
          Day03.Utils.get_idx_for_coords(adj_row, adj_col, height)
        end)
      end)
      |> List.flatten()
      |> Enum.sort()
      |> Enum.dedup()

    numbers_with_indices =
      num_chars
      |> Enum.reduce(
        [],
        fn {char, col, idx}, acc ->
          case acc do
            [] ->
              [{char, [idx]}]

            [{current_number_str, current_indices} | rest_acc] ->
              is_new_col = col == 0

              is_idx_consecutive =
                case current_indices do
                  [] -> false
                  [last_idx | _] -> last_idx == idx - 1
                end

              if is_new_col or not is_idx_consecutive do
                [{char, [idx]}] ++ acc
              else
                [{current_number_str <> char, [idx] ++ current_indices} | rest_acc]
              end
          end
        end
      )

    IO.inspect(numbers_with_indices, charlists: :as_lists)

    gear_numbers =
      numbers_with_indices
      |> Enum.reduce(
        %{},
        fn {number_str, indices}, acc ->
          {number, _} = Integer.parse(number_str)

          case affected_indices
               |> Enum.find(fn possible_match_idx -> possible_match_idx in indices end) do
            nil ->
              acc

            affected_idx ->
              case acc["#{affected_idx}"] do
                nil ->
                  acc
                  |> Map.put("#{affected_idx}", [number])

                numbers_arr ->
                  acc
                  |> Map.put("#{affected_idx}", numbers_arr ++ [number])
              end
          end
        end
      )

    IO.inspect(gear_numbers, charlists: :as_lists, limit: :infinity)

    valid_gear_numbers =
      gear_numbers
      |> Map.values()
      |> Enum.filter(fn numbers_arr -> length(numbers_arr) > 1 end)

    IO.inspect(valid_gear_numbers)

    valid_gear_numbers
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  defp get_flattened_with_index(list) do
    list
    |> List.flatten()
    |> Enum.with_index()
  end

  defp with_metadata(char_lines, width, height) do
    char_lines
    |> Enum.map(fn {char, idx} ->
      get_metadata({char, idx}, width, height)
    end)
  end

  defp get_metadata({char, idx}, width, height) do
    {row, col} = Day03.Utils.get_coords_at_idx(idx, width, height)
    char_type = get_type_of_char(char)
    {char, char_type, row, col, idx}
  end

  defp get_type_of_char("*"), do: :gear

  defp get_type_of_char(char) do
    case Integer.parse(char) do
      {_, _} -> :number
      _ -> nil
    end
  end
end

defmodule Mix.Tasks.Day03 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 03==")

    {:ok, input} = File.read("input/day03.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day03.Part1.solve(input))
    IO.puts("*** Part 2 ***")
    IO.puts(Day03.Part2.solve(input))
  end
end
