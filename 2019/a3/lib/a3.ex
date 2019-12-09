defmodule A3 do
  @moduledoc """
  Documentation for A3.
  """

  def points(schematic) do
    String.split(schematic, ",", trim: true)
    |> Enum.reduce([{0, 0}], fn direction, points ->
      starting = List.last(points)
      points ++ move(starting, direction)
    end
    )
  end

  def move({x, y}, direction) do
    <<dir::utf8, distance::bytes>> = direction
    distance = String.to_integer(distance)
    case dir do
      ?U -> for up <- 1..distance, do: {x, y + up}
      ?D -> for down <- 1..distance, do: {x, y - down}
      ?R -> for right <- 1..distance, do: {x + right, y}
      ?L -> for left <- 1..distance, do: {x - left, y}
    end
  end

  def intersections(schematic1, schematic2) do
    points1 = points(schematic1)
    points2 = points(schematic2)
    points1 -- (points1 -- points2)
  end

  def find_closest(points, point) do
    points -- [point]
    |> Enum.min_by(fn p -> distance(point, p) end)
  end

  def distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def find_distance_to_closest_intersection(schematic1, schematic2) do
   intersections(schematic1, schematic2)
   |> find_closest({0, 0})
   |> distance({0, 0})
  end

  def read_schematics(filename) do
    {:ok, contents} = File.read(filename)
    contents |> String.split("\n", trim: true)
  end

  def find_steps_to_soonest_intersection(schematic1, schematic2) do
    intersections(schematic1, schematic2) -- [{0, 0}]
    |> Enum.map(fn p -> steps(schematic1, p) + steps(schematic2, p) end)
    |> Enum.min
  end

  def steps(schematic, point) do
    points(schematic)
    |> Enum.find_index(fn p -> point == p end)
  end
end
