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

  test "total_fuel" do
    assert A1.total_fuel([12, 14]) == 4
  end

  test "part 1 solution" do
    assert A1.solve_part_1('input.txt') == 3249817
  end

  test "fuel_fuel" do
    assert A1.fuel_fuel(14) == 2
    assert A1.fuel_fuel(1) == 0
    assert A1.fuel_fuel(1969) == 966
  end

  test "part 2 solution" do
    assert A1.solve_part_2('input.txt') == 4871866
  end
end
