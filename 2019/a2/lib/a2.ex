defmodule A2 do
  @moduledoc """
  Documentation for A2.
  """

  def next_instruction(opcodes) do
    opcodes |> Enum.slice(0, 4)
  end

  def handle_instruction(opcode, input) do
    case opcode do
      [1, in1, in2, out] ->
        sum = Enum.at(input, in1) + Enum.at(input, in2)
        output = List.replace_at(input, out, sum)
        {:ok, output}
      [2, in1, in2, out] ->
        product = Enum.at(input, in1) * Enum.at(input, in2)
        output = List.replace_at(input, out, product)
        {:ok, output}
      [99|_] ->
        {:done, input}
    end
  end
end
