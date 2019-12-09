defmodule A3Test do
  use ExUnit.Case
  doctest A3

  test "move" do
    assert A3.move({0, 0}, "U1") == [{0, 1}]
  end

  test "move more" do
    assert A3.move({0, 0}, "L3") == [{-1, 0}, {-2, 0}, {-3, 0}]
  end

  test "find_points" do
    wire = "R1,D1"
    points = [{0, 0}, {1, 0}, {1, -1}]
    assert A3.points(wire) == points
  end

  test "intersections" do
    wire1 = "R1,D1"
    wire2 = "D1,R1"
    assert A3.intersections(wire1, wire2) == [{0, 0}, {1, -1}]
  end

  test "find_closest" do
    assert A3.find_closest([{-4, 3}, {5, 4}], {0, 0}) == {-4, 3}
  end

  test "find_closest filters out exact match" do
    assert A3.find_closest([{0, 0}, {-4, 3}, {5, 4}], {0, 0}) == {-4, 3}
  end

  test "distance check" do
    wire1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72"
    wire2 = "U62,R66,U55,R34,D71,R55,D58,R83"

    assert A3.find_distance_to_closest_intersection(wire1, wire2) == 159
  end

  test "distance check2" do
    wire1 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51"
    wire2 = "U98,R91,D20,R16,D67,R40,U7,R15,U6,R7"

    assert A3.find_distance_to_closest_intersection(wire1, wire2) == 135
  end

  test "solve1" do
    [wire1, wire2] = A3.read_schematics('input.txt')
    distance = A3.find_distance_to_closest_intersection(wire1, wire2)
    IO.puts "problem 1: #{distance}"
  end

  test "solve2" do
    [wire1, wire2] = A3.read_schematics('input.txt')
    steps = A3.find_steps_to_soonest_intersection(wire1, wire2)
    IO.puts "problem 2: #{steps}"
  end
end
