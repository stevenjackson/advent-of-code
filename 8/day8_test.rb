require 'minitest/autorun'
class Day8Test < MiniTest::Test
  def test_all_off_at_start
    screen = Screen.new
    0.upto(screen.last_row) do |row|
      0.upto(screen.last_column) do |col|
        assert_equal ".", screen.pixel_at(row, col)
      end
    end
  end

  def test_rect_turns_on
    screen = Screen.new
    screen.command("rect 1x1")
    assert_equal "#", screen.pixel_at(0, 0);
  end

  def test_bigger_rect
    screen = Screen.new
    screen.command("rect 10x4")
    assert_equal "#", screen.pixel_at(0, 0)
    assert_equal "#", screen.pixel_at(0, 9)
    assert_equal "#", screen.pixel_at(3, 0)
    assert_equal "#", screen.pixel_at(3, 9)
    assert_equal ".", screen.pixel_at(0, 10)
    assert_equal ".", screen.pixel_at(4, 10)
  end

  def test_rotate_column
    screen = Screen.new
    screen.turn_on(1, 2)
    screen.command("rotate column x=2 by 1")
    assert_equal "#", screen.pixel_at(2, 2)
    assert_equal ".", screen.pixel_at(1, 2)
  end

  def test_rotate_column_rollover
    screen = Screen.new
    screen.turn_on(screen.last_row, 1)
    screen.command("rotate column x=1 by 1")
    assert_equal "#", screen.pixel_at(0, 1)
    assert_equal ".", screen.pixel_at(screen.last_row, 1)
  end

  def test_rotate_row
    screen = Screen.new
    screen.turn_on(0, 5)
    screen.command("rotate row y=0 by 18")
    assert_equal "#", screen.pixel_at(0, 23)
    assert_equal ".", screen.pixel_at(0, 5)
  end

  def test_pt1
    screen = Screen.new
    full_input.each { |command| screen.command(command) }
    assert_equal 115, screen.lit_pixels
    puts "\n#{screen}"
  end

  def test_pt2
    screen = Screen.new
    full_input.each { |command| screen.command(command) }
    puts "\n" + "=" * 30 + "Part 2" + "=" * 30 + "\n"
    screen.to_s.split("\n").each do |row|
      row.chars.each_with_index do |c, index|
        print "  " if index % 5 == 0
        print c
      end
      print "\n"
    end
    puts "\n" + "=" * 65 + "\n"
  end

  def full_input
    File.read(File.join(__dir__, "input")).split("\n")
  end

  class Screen
    attr_reader :total_rows, :total_columns

    def initialize(rows = 6, cols = 50)
      @total_rows = rows
      @total_columns = cols
      @pixels = Array.new(rows) { Array.new(cols) { "." } }
    end

    def last_row
      total_rows - 1
    end

    def last_column
      total_columns - 1
    end

    def pixel_at(row, col)
      @pixels[row][col]
    end

    def turn_on(row, col)
      @pixels[row][col] = "#"
    end

    def to_s
      0.upto(last_row).map do |row|
        0.upto(last_column).map do |col|
          pixel_at(row, col)
        end.join
      end.join("\n")
    end

    def command(command)
      cmd, *args = command.split
      case cmd
      when "rect"
        dimensions = args.first
        cols, rows = dimensions.split "x"
        rect(cols, rows)
      when "rotate"
        direction, location, by, amount = *args
        index = location.split("=").last
        rotate(direction, index.to_i, amount.to_i)
      end
    end

    def rect(cols, rows)
      0.upto(rows.to_i - 1) do |row|
        0.upto(cols.to_i - 1) do |col|
          turn_on(row, col)
        end
      end
    end

    def rotate(direction, index, amount)
      case direction
      when "column"
        rotate_column(index, amount)
      when "row"
        rotate_row(index, amount)
      end
    end

    def rotate_column(col_idx, amount)
      rotated_column = column_at(col_idx).rotate(amount * -1)
      rotated_column.each_with_index do |value, row|
        @pixels[row][col_idx] = value
      end
    end

    def rotate_row(row_idx, amount)
      rotated_row = row_at(row_idx).rotate(amount * -1)
      rotated_row.each_with_index do |value, col|
        @pixels[row_idx][col] = value
      end
    end

    def column_at(index)
      0.upto(last_row).map { |row| pixel_at(row, index) }
    end

    def row_at(index)
      0.upto(last_column).map { |col| pixel_at(index, col) }
    end

    def lit_pixels
      0.upto(last_row).map do |row|
        0.upto(last_column).map do |col|
          pixel_at(row, col) == "#" ? 1 : 0
        end.reduce(:+)
      end.reduce(:+)
    end
  end
end
