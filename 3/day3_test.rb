require 'minitest/autorun'

class Day3Test < Minitest::Test
  def test_is_triangle
    input = "3 4 5"
    assert triangle? input
  end

  def test_not_triangle
    input = "12 1 2"
    assert_equal(false, triangle?(input))
  end

  def test_pt1
    full_input = File.read('input')
    count = full_input.split("\n").select { |line| triangle?(line.strip) }.count
    assert_equal 1050, count
  end

  def test_pt2

    ordered_input = build_input
    count = 0
    ordered_input.each_slice(3) do |trinput|
      count += 1  if triangle?(trinput.join(" "))
    end
    assert_equal 1921, count
  end

  def build_input
    full_input = File.read('input')
    lines = full_input.split("\n").map(&:strip)
    inputs = lines.map(&:split)
    ordered_input =
      inputs.map(&:first) +
      inputs.map { |parts| parts[1] } +
      inputs.map(&:last)
  end

  def count_triangles(input)
  end

  def triangle?(input)
    sides = input.split.map(&:to_i).sort
    sides[0] + sides[1] > sides[2]
  end
end
