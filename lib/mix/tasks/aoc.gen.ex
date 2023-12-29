defmodule Mix.Tasks.Aoc.Gen do
  use Mix.Task
  require Mix.Generator

  @shortdoc "Generates source files for a new day / puzzle"

  @moduledoc """
  # USAGE
  ```
  mix advent.gen <--day <day>>
  ```

  # DESCRIPTION
  Generates source files for a new Advent of Code day's puzzle and populates them with boilerplate code.

  ```
  /
  |- lib/
  | |- solution/
  | | |- day${DAY}.ex/
  |- test/
  | |- solution/
  | | |- day${DAY}_test.exs/
  |- input/
  | |- day${DAY}.txt
  ```
  """

  @impl Mix.Task
  def run(args) do
    with {[day: day], _, []} when day > 1 and day <= 25 <-
           OptionParser.parse(
             args,
             aliases: [d: :day],
             strict: [day: :integer]
           ) do
      generate(day)
    else
      _ -> Mix.shell().error("Invalid argument.")
    end
  end

  defp generate(day) do
    solution_dir = Path.join(lib_root_dir(), "solution")
    test_dir = Path.join(test_root_dir(), "solution")
    input_dir = input_root_dir()

    Mix.Generator.create_file(
      Path.join(
        solution_dir,
        :io_lib.format("day~2..0B.ex", [day])
      ),
      solution_template(day: day)
    )

    Mix.Generator.create_file(
      Path.join(
        test_dir,
        :io_lib.format("day~2..0B_test.exs", [day])
      ),
      test_template(day: day)
    )

    Mix.Generator.create_file(
      Path.join(
        input_dir,
        :io_lib.format("day~2..0B.txt", [day])
      ),
      "INPUT_HERE"
    )
  end

  defp lib_root_dir, do: Path.join(File.cwd!(), "lib")
  defp test_root_dir, do: Path.join(File.cwd!(), "test")
  defp input_root_dir, do: Path.join(File.cwd!(), "input")

  Mix.Generator.embed_template(:solution, """
  defmodule Day<%= :io_lib.format("~2..0B", [@day]) %>.Part1 do
    solve(input) do
      nil
    end
  end

  defmodule Day<%= :io_lib.format("~2..0B", [@day]) %>.Part2 do
    solve(input) do
      nil
    end
  end

  defmodule Mix.Tasks.Day<%= :io_lib.format("~2..0B", [@day]) %> do
    use Mix.Task

    def run(_) do
      IO.puts("==DAY <%= :io_lib.format("~2..0B", [@day]) %>==")

      {:ok, input} = File.read("input/day<%= :io_lib.format("~2..0B", [@day]) %>.txt")

      IO.puts("*** Part I ***")
      IO.puts(Day<%= :io_lib.format("~2..0B", [@day]) %>.Part1.solve(input))
      IO.puts("*** Part II ***")
      IO.puts(Day<%= :io_lib.format("~2..0B", [@day]) %>.Part2.solve(input))
    end
  end
  """)

  Mix.Generator.embed_template(:test, """
  defmodule Day<%= :io_lib.format("~2..0B", [@day]) %>Test do
    use ExUnit.Case

    alias Day<%= :io_lib.format("~2..0B", [@day]) %>.Part1, as: Part1
    alias Day<%= :io_lib.format("~2..0B", [@day]) %>.Part2, as: Part2

    @example \"\"\"
    EXAMPLE_INPUT_HERE
    \"\"\"

    @tag :skip
    @tag example: true
    test "solves the example input for part 1" do
      assert Part1.solve(@example) == nil
    end

    @tag :skip
    @tag example: true
    test "solves the example input for part 2" do
      assert Part2.solve(@example) == nil
    end
  end
  """)
end
