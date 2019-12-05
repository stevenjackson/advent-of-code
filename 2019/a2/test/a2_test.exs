defmodule A2Test do
  use ExUnit.Case
  doctest A2
  test "next_instruction simple" do
    assert A2.next_instruction([1, 9, 10, 3]) == [1, 9, 10, 3]
  end

  test "next_instruction simplish" do
    assert A2.next_instruction([1, 9, 10, 3, 44]) == [1, 9, 10, 3]
  end

  test "next_instruction 99" do
    assert A2.next_instruction([99]) == [99]
    # I'm ok with this for now - let the instruction processor figure it out
    assert A2.next_instruction([99, 1, 9, 10, 3, 44]) == [99, 1, 9, 10]
  end

  test "opcode 1" do
    program = [1, 1, 1, 1]
    assert A2.handle_instruction([1, 1, 1, 1], program) == {:ok, [1, 2, 1, 1]}
  end

  test "write out of bounds on opcode 1 does nothing?" do
    program = [1, 1, 1, 42]
    assert A2.handle_instruction([1, 1, 1, 42], program) == {:ok, [1, 1, 1, 42]}
  end

  test "opcode2" do
    program = [2, 1, 1, 1]
    assert A2.handle_instruction([2, 1, 1, 1], program) == {:ok, [2, 1, 1, 1]}
  end

  test "opcode 99" do
    program = [2, 1, 1, 1]
    assert A2.handle_instruction([99], program) == {:done, program}
  end

end
