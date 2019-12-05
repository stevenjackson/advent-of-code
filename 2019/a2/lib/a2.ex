defmodule A2 do
  @moduledoc """
  Documentation for A2.
  """

  @doc """
  Hello world.

  ## Examples

      iex> A2.hello()
      :world

  """
  def hello do
    :world
  end

  def next_instruction(opcodes) do
    opcodes |> Enum.slice(0, 4)
  end
end
