defmodule A4 do

  def find_matches(first, second) do
    (first..second)
    |> Enum.filter(&digits_increasing?/1)
    |> Enum.filter(&double_digits?/1)
  end

  def double_digits?(value) do
    double_digits = Integer.digits(value)
     |> Enum.reduce_while(-1, fn digit, prev_digit ->
       if digit == prev_digit, do: {:halt, true}, else: {:cont, digit}
     end)

    double_digits == true
  end

    double_digits == true
  end

  def digits_increasing?(value) do
    decreasing = Integer.digits(value)
     |> Enum.reduce_while(-1, fn digit, prev_digit ->
       if digit < prev_digit, do: {:halt, false}, else: {:cont, digit}
     end)

    decreasing != false
  end
end
