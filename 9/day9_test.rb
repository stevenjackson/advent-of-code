require 'minitest/autorun'
class Day9Test < MiniTest::Test
  def test_noop
    input = "ADVENT"
    assert_equal "ADVENT", decompress(input)
  end

  def test_single_char_compression
    input = "A(1x5)BC"
    assert_equal "ABBBBBC", decompress(input)
  end

  def test_multi_char_compression
    input = "(3x3)XYZ"
    assert_equal "XYZXYZXYZ", decompress(input)
  end

  def test_multi_part_compression
    input = "A(2x2)BCD(2x2)EFG"
    assert_equal "ABCBCDEFEFG", decompress(input)
  end

  def test_marker_confusion
    input = "(6x1)(1x3)A"
    assert_equal "(1x3)A", decompress(input)
  end

  def test_big_repeat
    input = "X(8x2)(3x3)ABCY"
    assert_equal "X(3x3)ABC(3x3)ABCY", decompress(input)
  end

  def test_pt1
    assert_equal 102239, decompress(full_input).length
  end

  def test_compute_length_one_marker
    input = "(3x3)XYZ"
    assert_equal 9, compute_length_v2(input)
  end

  def test_compute_length_double_marker
    input = "X(8x2)(3x3)ABCY"
    assert_equal 20, compute_length_v2(input)
  end

  def test_compute_length_stacked_markers
    input = "(27x12)(20x12)(13x14)(7x10)(1x12)A"
    assert_equal 241920, compute_length_v2(input)
  end

  def test_compute_length_complex
    input = "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
    assert_equal 445, compute_length_v2(input)
  end

  def test_part2
    assert_equal 10780403063, compute_length_v2(full_input)
  end

  def full_input
    File.read(File.join(__dir__, "input")).chomp
  end

  def decompress(input)
    input = StringIO.new(input)
    output = StringIO.new
    until input.eof? do
      temp = input.gets("(").chomp("(")
      output << temp
      repeater = input.gets(")").chomp(")") unless input.eof?
      if repeater
        chars, count = repeater.split "x"
        repeated = input.gets(chars.to_i)
        output << repeated * count.to_i
      end
      repeater = nil
    end
    output.string
  end

  def compute_length_v2(input)
    input = StringIO.new(input)
    length = 0
    until input.eof? do
      temp = input.gets("(").chomp("(")
      length += temp.length
      repeater = input.gets(")").chomp(")") unless input.eof?
      if repeater
        chars, count = repeater.split "x"
        repeated = input.gets(chars.to_i) * count.to_i
        length += compute_length_v2(repeated)
      end
      repeater = nil
    end
    length
  end
end
