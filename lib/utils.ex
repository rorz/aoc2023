defmodule Utils do
  def split_into_lines(input) do
    String.split(input, "\n", trim: true)
  end

  def to_int(str) do
    {num, _} = Integer.parse(str)
    num
  end
end
