defmodule A2 do
  @moduledoc """
  Documentation for A2.
  """

  def next_instruction(index, opcodes) do
    opcodes |> Enum.slice(index, 4)
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
      _ ->
        {:error, input}
    end
  end

  def run_program(program) do
    run_program(0, program)
  end

  def run_program(index, program) do
    instruction = next_instruction(index, program)
    result = handle_instruction(instruction, program)
    case result do
      {:ok, program} ->
        index = index + length(instruction)
        run_program(index, program)
       _ ->
         result
    end
  end

  def read_program(filename) do
    {:ok, contents} = File.read(filename)
   contents
    |> String.trim
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def execute(program_file, noun, verb) do
    {code, program}  = read_program(program_file)
    |> set_input(noun, verb)
    |> run_program

    {code, Enum.at(program, 0)}
  end

  def set_input(program, noun, verb) do
    program
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  def find_part2(input, target) do
    target? = fn(input, noun, verb) -> execute(input, noun, verb) == {:done, target} end
    for noun <- 0..100, verb <- 0..100, target?.(input, noun, verb), do: { noun, verb, target }
  end
end
