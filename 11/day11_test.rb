require 'minitest/autorun'
class Day11Test < MiniTest::Test

  def test_floor_safe_no_gens
    building = Building.new(["CoM PuM"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_no_chips
    building = Building.new(["CoG PuG"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_pair
    building = Building.new(["CoG CoM"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_pair_with_other_generators
    building = Building.new(["CoG CoM PmG"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_chips_fried
    building = Building.new(["CoG PuM"])
    assert_equal false, building.floor_safe?(0)
  end

  def test_pt1
    building =  Building.new(initial_state)
    building.move_up("PmG", "PmM")
    building.move_up("PmM")
    building.move_down("CoM", "CmM")
    building.move_up("CoM")
    building.move_down("CoM", "RuM")
    building.move_up("CoM")
    building.move_down("CoM", "PuM")
    building.move_down("CoM", "PuM")
    building.move_up("PuM")
    2.times{ building.move_up("CoG", "PmG") }
    2.times{ building.move_down("PmG") }
    building.move_down("CmM", "PuM")
    building.move_up("PuM")
    2.times{ building.move_up("CmG", "PmG") }
    2.times{ building.move_down("PmG") }
    building.move_down("RuM", "PuM")
    building.move_up("PuM")
    2.times{ building.move_up("RuG", "PmG") }
    2.times{ building.move_down("PmG") }
    2.times{ building.move_up("PmG", "PuG") }
    building.move_down("PmG")
    building.move_up("PmG", "PmM")
    3.times { building.move_down("PmM") }
    3.times { building.move_up("CoM", "PmM") }
    3.times { building.move_down("PmM") }
    3.times { building.move_up("CmM", "PmM") }
    3.times { building.move_down("PmM") }
    3.times { building.move_up("RuM", "PmM") }
    2.times { building.move_down("PmM") }
    2.times { building.move_up("PmM", "PuM") }
    puts building.to_s
    puts "MOVES #{building.move_counter}"
  rescue
    puts building.to_s
    puts "MOVES #{building.move_counter}"
    raise $!
  end

  def initial_state
    %{ PmG PmM
       CoG CmG RuG PuG
       CoM CmM RuM PuM
                        }
      .split("\n").map(&:strip)
  end

  class Building
    attr_reader :move_counter, :generators, :chips, :top_floor
    def initialize(state)
      parse(state)
      @top_floor = state.length - 1
      @elevator = 0
      @move_counter = 0
    end

    def parse(state)
      @generators = []
      @chips = []
      state.each_with_index do |floor, index|
        floor.split.each do |item|
          if item.end_with? "G"
            generator = Generator.new(item.chomp("G"))
            generator.floor = index
            generators << generator
          else
            chip = Chip.new(item.chomp("M"))
            chip.floor = index
            chips << chip
          end
        end
      end
    end

    def current_floor
      floor(@elevator)
    end

    def floor(index)
      (@generators + @chips).select { |item| item.floor == index }
    end

    def move_up(item1, item2=nil)
      raise 'cant go up' if @elevator == @top_floor
      move(item1, item2, 1)
    end

    def move_down(item1, item2=nil)
      raise 'cant go down' if @elevator == 0
      move(item1, item2, -1)
    end

    def to_state
      pairs
      { elevator: @elevator,
        pairs: pairs
      }
    end

    def find_item(item)
      return unless item
      if item.end_with? "G"
        @generators.find { |generator| generator.element == item.chomp("G") }
      else
        @chips.find { |chip| chip.element == item.chomp("M") }
      end
    end

    def move(item1, item2, direction)
      item1 = find_item(item1)
      item2 = find_item(item2)
      raise 'nothing to move' unless current_floor.include? item1

      @elevator += direction
      item1.floor += direction
      item2.floor += direction if item2
      @move_counter += 1
      raise 'fried' unless safe?
    end

    def floor_safe?(index)
      floor = floor(index)
      generators, chips = floor.partition { |item| item.is_a? Generator }
      all_paired = chips.all? do |chip|
        generators.any? { |generator| generator.element == chip.element }
      end

      return generators.none? || chips.none? || all_paired
    end

    def safe?
      0.upto(top_floor).all? { |floor| floor_safe?(floor) }
    end

    def to_s
      output = StringIO.new
      output << "\n" + "=" * 40 + "\n"
      0.upto(top_floor) do |index|
        if @elevator == index
          output << "E"
        else
          output << "|"
        end
        output << " #{floor(index)}\n"
      end
      output << "=" * 40 + "\n"
      output.string
    end
  end

  class Generator
    attr_reader :element
    attr_accessor :floor
    def initialize(element)
      @element = element
    end

    def to_s
      element + "G"
    end
    alias_method :inspect, :to_s
  end

  class Chip
    attr_reader :element
    attr_accessor :floor
    def initialize(element)
      @element = element
    end
    def to_s
      element + "M"
    end
    alias_method :inspect, :to_s
  end
end
