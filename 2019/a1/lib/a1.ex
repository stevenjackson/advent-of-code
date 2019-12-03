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
    div(mass, 3) - 2
  end
end
