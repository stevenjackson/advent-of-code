require 'minitest/autorun'
class Day11Test < MiniTest::Test

  def test_floor_safe_no_gens
    building = Building.parse(["CoM PuM"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_no_chips
    building = Building.parse(["CoG PuG"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_pair
    building = Building.parse(["CoG CoM"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_floor_safe_pair_with_other_generators
    building = Building.parse(["CoG CoM PmG"])
    assert_equal true, building.floor_safe?(0)
  end

  def test_chips_fried
    building = Building.parse(["CoG PuM"])
    assert_equal false, building.floor_safe?(0)
  end

  def test_safe_moves
    building = Building.parse(["PuM", "CoG CoM", "PuG"])
    building.elevator = 1
    assert_equal 3, building.safe_moves.count
  end

  def test_p1_1_bfs
    initial_state = Building.parse(pt1_input).to_graph
    target_state = { elevator: 3, pairs: 5.times.map { [3,3] } }
    path_back = BreadthFirstSearch.new.search(initial_state, target_state)
    step = target_state
    count = 0
    while step != initial_state
      step = path_back[step]
      count += 1
    end

    assert_equal 33, count
  end

  def test_pt2
    initial_state = Building.parse(pt2_input).to_graph
    target_state = { elevator: 3, pairs: 7.times.map { [3,3] } }
    path_back = BreadthFirstSearch.new.search(initial_state, target_state)
    step = target_state
    count = 0
    while step != initial_state
      step = path_back[step]
      count += 1
    end

    assert_equal 57, count
  end

  def test_pt1_manual
    building =  Building.parse(pt1_input)
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

  def pt1_input
    %{ PmG PmM
       CoG CmG RuG PuG
       CoM CmM RuM PuM
                        }
      .split("\n").map(&:strip)
  end

  def pt2_input
    %{ PmG PmM ElG ElM DiG DiM
       CoG CmG RuG PuG
       CoM CmM RuM PuM
                        }
      .split("\n").map(&:strip)
  end

  class Building
    attr_reader :move_counter, :generators, :chips, :top_floor
    attr_accessor :elevator
    def initialize(generators:, chips:, num_floors:, elevator: 0)
      @generators = generators
      @chips = chips
      @top_floor = num_floors - 1
      @elevator = elevator
      @move_counter = 0
    end

    def self.parse(state)
      generators = []
      chips = []
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
      Building.new(generators: generators, chips: chips, num_floors: state.length)
    end

    def to_graph
      elements = @generators.map { |generator| generator.element }
      pairs = elements.map do |element|
        [
          @generators.find { |generator| generator.element == element }.floor,
          @chips.find { |chips| chips.element == element }.floor
        ]
      end
      {
        elevator: @elevator,
        pairs: pairs.sort
      }
    end

    def self.from_graph(graph)
      elements = %w(Pm Co Ru Pu Cm El Di)
      generators = []
      chips = []
      graph[:pairs].each do |pair|
        element = elements.shift
        generators << generator = Generator.new(element)
        chips << chip = Chip.new(element)
        generator.floor, chip.floor = pair
      end
      elevator = graph[:elevator]
      Building.new(generators: generators, chips: chips, elevator: elevator, num_floors: 4)
    end

    def safe_moves
      MoveCalculator.new(to_graph).safe_moves
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

    def move(item1, item2, direction)
      safe = test_move(item1, item2, direction)
      raise 'fried' unless safe
      @move_counter += 1
    end

    def test_move(item1, item2, direction)
      item1 = find_item(item1)
      item2 = find_item(item2)
      raise 'nothing to move' unless current_floor.include? item1
      @elevator += direction
      item1.floor += direction
      item2.floor += direction if item2
      safe?
    end

    def find_item(item)
      return unless item
      item = item.to_s
      if item.end_with? "G"
        @generators.find { |generator| generator.element == item.chomp("G") }
      else
        @chips.find { |chip| chip.element == item.chomp("M") }
      end
    end

    def safe?
      0.upto(top_floor).all? { |floor| floor_safe?(floor) }
    end

    def floor_safe?(index)
      floor = floor(index)
      generators, chips = floor.partition { |item| item.is_a? Generator }
      all_paired = chips.all? do |chip|
        generators.any? { |generator| generator.element == chip.element }
      end

      return generators.none? || chips.none? || all_paired
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

  class BreadthFirstSearch
    def search(state, target_state)
      queue = [state]
      visited = [state]
      path_back = {}

      while queue.any?
        from_state = queue.shift
        valid_moves(from_state).each do |next_state|
          next if visited.include? next_state
          queue << next_state
          visited << next_state
          path_back[next_state] = from_state
          if next_state == target_state
            return path_back
          end
        end
        puts "queue length #{queue.length}" if queue.length % 100 == 0
      end
      path_back
    end

    def valid_moves(graph)
      MoveCalculator.new(graph).safe_moves
    end
  end

  class MoveCalculator
    def initialize(graph)
      @initial_graph = graph
    end

    def safe_moves
      building = Building.from_graph(@initial_graph)
      items = building.current_floor
      up_moves = building.elevator < building.top_floor ? safe_moves_for(items, 1) : []
      down_moves = building.elevator > 0  ? safe_moves_for(items, -1) : []
      up_moves + down_moves
    end


    def safe_moves_for(items, direction)
      possible_combinations = (1..2).flat_map{|size| items.combination(size).to_a }
      moves = possible_combinations.map { |combo| graph_if_safe(*combo, direction) }
      moves.compact
    end

    def graph_if_safe(item1, item2=nil, direction)
      building = Building.from_graph(@initial_graph)
      if building.test_move(item1, item2, direction)
        building.to_graph
      end
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
