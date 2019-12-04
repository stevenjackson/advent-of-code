defmodule A1 do
  @moduledoc """
  Documentation for A1.
  """

  @doc """
  Fuel required to launch a given module is based on its mass. Specifically, to
  find the fuel required for a module, take its mass, divide by three, round
  down, and subtract 2.

  ## Examples

      iex> A1.fuel(12)
      2

  """
  def fuel(mass) do
    fuel = div(mass, 3) - 2
    if fuel > 0 , do: fuel, else: 0
  end

  def read_masses(filename) do
    {:ok, contents} = File.read(filename)
    contents |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def total_fuel(masses) do
    Enum.map(masses, &fuel/1)
    |> Enum.sum
  end

  def solve_part_1(filename) do
    read_masses(filename) |> total_fuel
  end

  def fuel_fuel(mass) when mass > 0 do
    remaining_mass = fuel(mass)
    remaining_mass + fuel_fuel(remaining_mass)
  end

  def fuel_fuel(_mass) do
    0
  end

  def solve_part_2(filename) do
    read_masses(filename)
    |> Enum.map(&fuel_fuel/1)
    |> Enum.sum
  end
end
