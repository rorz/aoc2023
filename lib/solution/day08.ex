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

  def traverse(instructions, network_map, start_at, stop_at, curr_move) do
    curr_idx = rem(curr_move - 1, length(instructions))
    instruction = instructions |> Enum.at(curr_idx)
    {left_target, right_target} = network_map[start_at]

    target =
      case instruction do
        :left -> left_target
        :right -> right_target
      end

    if Regex.match?(stop_at, target) do
      curr_move
    else
      traverse(instructions, network_map, target, stop_at, curr_move + 1)
    end
  end
end

defmodule Day08.Part1 do
  def solve(input) do
    {instructions, network_map} =
      input |> Day08.Utils.parse_input()

    instructions
    |> traverse(network_map)
  end

  defp traverse(instructions, network_map) do
    Day08.Utils.traverse(instructions, network_map, "AAA", ~r/ZZZ/, 1)
  end
end

defmodule Day08.Part2 do
  def solve(input) do
    {instructions, network_map} =
      input |> Day08.Utils.parse_input()

    network_map
    |> get_keys_with(~r/A$/)
    |> Enum.map(&traverse(instructions, network_map, &1))
    |> lowest_common_multiple()
  end

  defp traverse(instructions, network_map, key) do
    Day08.Utils.traverse(instructions, network_map, key, ~r/Z$/, 1)
  end

  defp get_keys_with(map, regex) do
    map
    |> Enum.reduce([], fn {key, _}, acc ->
      if Regex.match?(regex, key), do: [key | acc], else: acc
    end)
  end

  defp lowest_common_multiple(int_list) do
    import Math

    int_list
    |> Enum.reduce(1, fn cycle, acc ->
      lcm(acc, cycle)
    end)
  end
end

# too low = 31276215

defmodule Mix.Tasks.Day08 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 08==")

    {:ok, input} = File.read("input/day08.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day08.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day08.Part2.solve(input))
  end
end
