defmodule A2Test do
  use ExUnit.Case
  doctest A2

  test "greets the world" do
    assert A2.hello() == :world
  end

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
end
