defmodule A1Test do
  use ExUnit.Case
  doctest A1

  test "12" do
    assert A1.fuel(12) == 2
  end

  test "14" do
    assert A1.fuel(14) == 2
  end

  test "1969" do
    assert A1.fuel(1969) == 654
  end

  test "100756" do
    assert A1.fuel(100756) == 33583
  end
end
