defmodule A4Test do
  use ExUnit.Case

  test "double digits" do
    assert A4.double_digits?(11)
    refute A4.double_digits?(12)
    assert A4.double_digits?(4113)
  end

  test "increasing digits" do
    assert A4.digits_increasing?(123)
    refute A4.digits_increasing?(321)
    refute A4.digits_increasing?(198)
    assert A4.digits_increasing?(379)
  end

  test "finding matches" do
    matches = (121..123)
      |> Enum.filter(&A4.digits_increasing?/1)
      |> Enum.filter(&A4.double_digits?/1)
    assert matches == [122]
  end

  test "Solution 1" do
    matches = (138241..674034)
      |> Enum.filter(&A4.digits_increasing?/1)
      |> Enum.filter(&A4.double_digits?/1)
    IO.inspect  matches
    IO.puts "problem 1: #{length(matches)}"
  end

  test "has_double" do
    assert A4.has_double?(11)
    refute A4.has_double?(111)
    assert A4.has_double?(11122)
  end

  test "Solution 2" do
    matches = (138241..674034)
      |> Enum.filter(&A4.digits_increasing?/1)
      |> Enum.filter(&A4.double_digits?/1)
      |> Enum.filter(&A4.has_double?/1)
    IO.inspect  matches
    IO.puts "problem 2: #{length(matches)}"
  end
end
