defmodule Day06.Utils do
  def get_race_results(input) do
    Utils.split_into_lines(input)
    |> Enum.map(&parse_times_from_line/1)
    |> Enum.zip()
  end

  defp parse_times_from_line(line) do
    line
    |> get_number_part_from_line()
    |> String.split(" ", trim: true)
    |> Enum.map(fn num_str ->
      {num, _} = Integer.parse(num_str)
      num
    end)
  end

  defp get_number_part_from_line(line) do
    [_, numbers] =
      line |> String.split(":", trim: true)

    numbers
  end

  def get_winning_range_for_result({time_limit, distance_to_beat}) do
    lower_bound =
      stop_at_winning_time(
        0..time_limit,
        time_limit,
        distance_to_beat
      )

    upper_bound =
      stop_at_winning_time(
        time_limit..0,
        time_limit,
        distance_to_beat
      )

    lower_bound..upper_bound
  end

  defp get_distance_for(ms_button_pressed, time_limit) do
    go_distance = time_limit - ms_button_pressed
    go_distance * ms_button_pressed
  end

  defp stop_at_winning_time(search_range, time_limit, distance_to_beat) do
    search_range
    |> Enum.reduce_while(0, fn ms_button_pressed, _ ->
      case get_distance_for(ms_button_pressed, time_limit) do
        distance when distance > distance_to_beat ->
          {:halt, ms_button_pressed}

        _ ->
          {:cont, ms_button_pressed}
      end
    end)
  end
end

defmodule Day06.Part1 do
  def solve(input) do
    race_results = Day06.Utils.get_race_results(input)

    race_results
    |> Enum.map(&Day06.Utils.get_winning_range_for_result/1)
    |> Enum.map(fn range -> Range.size(range) end)
    |> Enum.product()
  end
end

defmodule Day06.Part2 do
  def solve(input) do
    all_race_results = Day06.Utils.get_race_results(input)

    combined_race_result =
      all_race_results
      |> Enum.reduce({0, 0}, fn {time_part, distance_part}, {acc_time, acc_distance} ->
        {new_time, _} = Integer.parse(Integer.to_string(acc_time) <> Integer.to_string(time_part))

        {new_distance, _} =
          Integer.parse(Integer.to_string(acc_distance) <> Integer.to_string(distance_part))

        {new_time, new_distance}
      end)

    combined_race_result
    |> Day06.Utils.get_winning_range_for_result()
    |> Range.size()
  end
end

defmodule Mix.Tasks.Day06 do
  use Mix.Task

  def run(_) do
    IO.puts("==DAY 06==")

    {:ok, input} = File.read("input/day06.txt")

    IO.puts("*** Part I ***")
    IO.puts(Day06.Part1.solve(input))
    IO.puts("*** Part II ***")
    IO.puts(Day06.Part2.solve(input))
  end
end
