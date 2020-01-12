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

  test "find_matches" do
    assert A4.find_matches(121, 123) == [122]
  end

  test "Solution 1" do
    matches = A4.find_matches(138241, 674034)
    IO.inspect  matches
    IO.inspect length(matches)
  end
end
