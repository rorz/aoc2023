defmodule Utils do
  def split_into_lines(input) do
    String.split(input, "\n", trim: true)
  end
end
