defmodule Day08.Utils do
  def parse_input(input) do
    {instruction_line, map_lines_str} =
      input |> break_input_into_instructions_and_map_str()

    instructions =
      instruction_line |> parse_instructions()

    network_map =
      map_lines_str |> parse_network_map()

    {instructions, network_map}
  end

  defp break_input_into_instructions_and_map_str(input) do
    input
    |> String.split("\n\n", trim: true)
    |> List.to_tuple()
  end

  defp parse_instructions(instruction_line) do
    instruction_line
    |> String.graphemes()
    |> Enum.map(fn instruction ->
      case instruction do
        "L" -> :left
        "R" -> :right
      end
    end)
  end

  defp parse_network_map(map_lines_str) do
    map_lines_str
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn map_line, acc ->
      {key, left_map, right_map} = map_line |> parse_key_and_mapping()
      acc |> Map.put(key, {left_map, right_map})
    end)
  end

  defp parse_key_and_mapping(map_line) do
    map_line
    |> String.replace(~r/[\ \=\(\)\,]/, " ")
    |> String.split(" ", trim: true)
    |> List.to_tuple()
  end
end

defmodule Day08.Part1 do
  def solve(input) do
    {instructions, network_map} =
      input |> Day08.Utils.parse_input()

    traverse(instructions, network_map)
  end

  defp traverse(instructions, network_map) do
    traverse(instructions, 0, "AAA", "ZZZ", network_map, 1)
  end

  def traverse(
        instructions,
        instr_idx,
        start_at,
        stop_at,
        network_map,
        moves
      ) do
    instruction = instructions |> Enum.at(instr_idx)
    {left_target, right_target} = network_map[start_at]

    next_idx_unbounded = instr_idx + 1
    next_idx = rem(next_idx_unbounded, length(instructions))

    case instruction do
      :left ->
        if left_target == stop_at do
          moves
        else
          traverse(
            instructions,
            next_idx,
            left_target,
            stop_at,
            network_map,
            moves + 1
          )
        end

      :right ->
        if right_target == stop_at do
          moves
        else
          traverse(
            instructions,
            next_idx,
            right_target,
            stop_at,
            network_map,
            moves + 1
          )
        end
    end
  end
end

defmodule Day08.Part2 do
  def solve(input) do
    nil
  end
end

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 08==")

    {:ok, input} = File.read("input/day08.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day08.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day07.Part2.solve(input))
  end
end
