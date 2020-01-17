defmodule A4 do

  def repeating_digits?(value) when is_integer(value), do: repeating_digits?(Integer.digits(value))
  def repeating_digits?([first, second | _rest]) when first == second, do: true
  def repeating_digits?([_first | rest]), do: repeating_digits?(rest)
  def repeating_digits?([]), do: false

  def digits_increasing?(value) when is_integer(value), do: digits_increasing?(Integer.digits(value))
  def digits_increasing?([first, second | _rest]) when first > second, do: false
  def digits_increasing?([_first | rest]), do: digits_increasing?(rest)
  def digits_increasing?([]), do: true

  def has_double?(value) do
    Integer.digits(value)
    |> Enum.chunk_by(fn(x) -> x end)
    |> Enum.any?(fn x -> length(x) == 2 end)
  end
end
