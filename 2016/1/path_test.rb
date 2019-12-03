require "minitest/autorun"

class TestWalk < Minitest::Test
  def test_turn_and_walk
    assert_equal 1, walk("R1").distance
  end

  def test_turn_and_walk2
    assert_equal 2, walk("R2").distance
  end

  def test_turn_and_walk_twice
    assert_equal 3, walk("R1, R2").distance
  end

  def test_backtrack
    assert_equal 1, walk("R1, R1, R1").distance
  end

  def test_next_direction_is_East
    assert_equal :E, Walk.new.next_direction("R")
  end

  def test_next_direction_is_South
    walker = Walk.new
    walker.next_direction("R")
    south = walker.next_direction("R")
    assert_equal :S, south
  end

  def test_next_direction_is_West
    assert_equal :W, Walk.new.next_direction("L")
  end

  def test_multi
    assert_equal 200, walk("R1, R1, R1, R1, R188, R32, R20").distance
  end

  def test_full
    assert_equal 307, walk(full_input).distance
  end

  def test_overlap_path
    path = walk(full_input).path
    dupes = path.group_by{ |e| e }.select { |k, v| v.size > 1 }
    assert_equal [-1, 164], dupes.first.first
  end

  def full_input
    "R1, R3, L2, L5, L2, L1, R3, L4, R2, L2, L4, R2, L1, R1, L2, R3, L1, L4, R2, L5, R3, R4, L1, R2, L1, R3, L4, R5, L4, L5, R5, L3, R2, L3, L3, R1, R3, L4, R2, R5, L4, R1, L1, L1, R5, L2, R1, L2, R188, L5, L3, R5, R1, L2, L4, R3, R5, L3, R3, R45, L4, R4, R72, R2, R3, L1, R1, L1, L1, R192, L1, L1, L1, L4, R1, L2, L5, L3, R5, L3, R3, L4, L3, R1, R4, L2, R2, R3, L5, R3, L1, R1, R4, L2, L3, R1, R3, L4, L3, L4, L2, L2, R1, R3, L5, L1, R4, R2, L4, L1, R3, R3, R1, L5, L2, R4, R4, R2, R1, R5, R5, L4, L1, R5, R3, R4, R5, R3, L1, L2, L4, R1, R4, R5, L2, L3, R4, L4, R2, L2, L4, L2, R5, R1, R4, R3, R5, L4, L4, L5, L5, R3, R4, L1, L3, R2, L2, R1, L3, L5, R5, R5, R3, L4, L2, R4, R5, R1, R4, L3"
  end

  def walk(input)
    Walk.new.walk(input)
  end

  class Walk
    attr_reader :path
    def initialize
      @distance_table = { N: 0, E: 0, W: 0, S: 0 }
      @path = [[0,0]]
      @last_direction = :N
    end

    def walk(input)
      input.split.each do |value|
        direction = next_direction(value[0])
        distance = value[1..-1].to_i
        @distance_table[direction] = @distance_table[direction] + distance
        add_to_path(direction, distance)
      end
      self
    end

    def distance
      north_distance = @distance_table[:N] - @distance_table[:S]
      east_distance = @distance_table[:E] - @distance_table[:W]
      north_distance.abs + east_distance.abs
    end

    def next_direction(turn)
      directions = [:N, :E, :S, :W]
      if turn == "R"
        next_index = directions.index(@last_direction) + 1
        @last_direction = directions[next_index % directions.length]
      else
        next_index = directions.index(@last_direction) - 1
        @last_direction = directions[next_index]
      end
    end

    def add_to_path(direction, distance)
      distance.downto(1).each do |_|
        n, e = @path.last
        case direction
        when :N
          @path << [n + 1, e]
        when :E
          @path << [n, e + 1]
        when :W
          @path << [n, e - 1]
        when :S
          @path << [n - 1, e]
        end
      end
    end
  end
end
