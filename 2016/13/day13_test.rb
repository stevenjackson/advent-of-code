require 'minitest/autorun'
require 'ostruct'

class Day13Test < MiniTest::Test
  SEED = 1352
  def test_is_wall
    assert_equal false, wall?(1,2)
  end

  def wall?(x,y)
    magic_number = (x*x + 3*x + 2*x*y + y + y*y) + SEED
    num_ones = magic_number.to_s(2).count("1")
    return !num_ones.even?
  end

  class GoDijkstraGo < Array
    attr_reader :edges

    def initialize
      @edges = []
    end

    def connect(from, to, length=1)
      @edges.push(OpenStruct.new(from: from, to: to, length: length))
    end

  end

end
