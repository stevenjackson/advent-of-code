defmodule A4 do
  def double_digits?(value) do
    double_digits = Integer.digits(value)
     |> Enum.reduce_while(-1, fn digit, prev_digit ->
       if digit == prev_digit, do: {:halt, true}, else: {:cont, digit}
     end)

    double_digits == true
  end

  def digits_increasing?([first, second | _rest]) when first > second, do: false
  def digits_increasing?([_first | rest]), do: digits_increasing?(rest)
  def digits_increasing?([]), do: true
  def digits_increasing?(value), do: digits_increasing?(Integer.digits(value))

  def has_double?(value) do
    find_matches(value)
    |> Enum.any?(fn x -> length(x) == 2 end)
  end

  def find_matches(value) do
    Integer.digits(value)
    |> Enum.chunk_by(fn(x) -> x end)
  end
end
