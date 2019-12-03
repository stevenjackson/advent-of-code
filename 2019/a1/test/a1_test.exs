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

  test "read masses" do
    masses = A1.read_masses('input.txt')
    assert length(masses) == 100
    assert List.first(masses) == 119031
    assert List.last(masses) == 121214
  end
end
