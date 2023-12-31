defmodule Day02.Part1 do
  @cube_limits %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  def solve(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&parse_game/1)
    |> Enum.map(&get_game_sum_value/1)
    |> Enum.sum()
  end

  def get_number_or_zero(string) do
    case Integer.parse(string) do
      {number, _} ->
        number

      :error ->
        0
    end
  end

  defp get_game_number("Game " <> game_number_string) do
    get_number_or_zero(game_number_string)
  end

  def parse_game(game_line) do
    [game_def, cube_lists_string] = String.split(game_line, ":")
    game_number = get_game_number(game_def)

    results =
      String.split(cube_lists_string, ";")
      |> Enum.map(&String.trim/1)
      |> Enum.flat_map(fn game_string ->
        game_string
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(fn count ->
          [count_string, color] = String.split(count, " ")
          [color, get_number_or_zero(count_string)]

          count_value = get_number_or_zero(count_string)
          limit = @cube_limits[color]

          case count_value <= limit do
            true -> :pass
            false -> :fail
          end
        end)
      end)

    [game_number, Enum.all?(results, fn result -> result == :pass end)]
  end

  def get_game_sum_value(game_result) do
    [game_number, result] = game_result

    case result do
      true -> game_number
      false -> 0
    end
  end
end

defmodule Day02.Part2 do
  def solve(input) do
    input
    |> Utils.split_into_lines()
    |> Enum.map(&parse_game/1)
    |> Enum.sum()
  end

  defp get_color_value_pairs(cube_lists_string) do
    Regex.split(~r/[,;]/, cube_lists_string)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(Map.new(), fn cube_string, acc ->
      [value_string, color] = String.split(cube_string, " ")
      value = Utils.to_int(value_string)

      Map.update(acc, color, [value], fn values ->
        [value | values]
      end)
    end)
  end

  defp parse_game(game_line) do
    [_, cube_lists_string] = String.split(game_line, ":")

    get_color_value_pairs(cube_lists_string)
    |> Map.values()
    |> Enum.map(&Enum.max/1)
    |> Enum.product()
  end
end

defmodule Mix.Tasks.Day02 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 02==")

    {:ok, input} = File.read("input/day02.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day02.Part1.solve(input))
    IO.puts("*** Part 2 ***")
    IO.puts(Day02.Part2.solve(input))
  end
end
