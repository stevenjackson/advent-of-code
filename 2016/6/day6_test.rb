require 'minitest/autorun'

class Day6Test < MiniTest::Test
  def test_initial
    input = %w(
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    )
    message = columns(input).map do |column|
      histogram(column).max_by { |k, v| v }.first
    end.join
    assert_equal "easter", message
  end

  def test_pt1
    message = columns(full_input).map do |column|
      histogram(column).max_by { |k, v| v }.first
    end.join
    assert_equal "kqsdmzft", message
  end

  def test_pt2
    message = columns(full_input).map do |column|
      histogram(column).min_by { |k, v| v }.first
    end.join
    assert_equal "tpooccyo", message
  end

  def full_input
    File.read(File.join(__dir__, 'input')).split("\n")
  end

  def columns(input)
    total_positions = input.first.length
    0.upto(total_positions - 1).map do |position|
      chars_at(input, position)
    end
  end

  def histogram(chars)
    chars.group_by { |char| char }.map { |k, v| Hash[k, v.count]}.reduce(&:merge)
  end

  def chars_at(input, position)
    input.map { |line| line[position] }
  end
end
