defmodule A1Test do
  use ExUnit.Case
  doctest A1

  test "12" do
    assert A1.fuel(12) == 2
  end
end
