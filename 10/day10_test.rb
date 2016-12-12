require 'minitest/autorun'
class Day10Test < MiniTest::Test
  def test_bots_created
    input = "bot 2 gives low to bot 1 and high to bot 0"
    program = Program.run(input)
    assert_equal 3, program.bots.length
  end

  def test_outputs_created
    input = "bot 1 gives low to output 1 and high to bot 0"
    program = Program.run(input)
    assert_equal 1, program.outputs.length
  end

  def test_value_assigned
    input = "value 5 goes to bot 2"
    program = Program.run(input)
    assert_equal 5, program.bots[2].chips.min
  end

  def test_2_chips_causes_move
    input = %{
    bot 2 gives low to bot 1 and high to bot 0
    value 5 goes to bot 2
    value 3 goes to bot 2
    }

    program = Program.run(input)
    assert_equal 3, program.bots[1].chips.min
    assert_equal 5, program.bots[0].chips.min
  end

  def test_give_chip_to_output
    input = %{
    bot 2 gives low to bot 1 and high to output 0
    value 5 goes to bot 2
    value 3 goes to bot 2
    }
    program = Program.run(input)
    assert_equal 3, program.bots[1].chips.min
    assert_equal 5, program.outputs[0].value
  end

  def test_bot_for
    input = %{
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    }

    program = Program.run(input)
    assert_equal 0, program.bot_for(3, 5).id
    assert_equal 1, program.bot_for(2, 3).id
    assert_equal 2, program.bot_for(2, 5).id
  end

  def test_pt1
    program = Program.run(full_input)
    assert_equal 118, program.bot_for(61, 17).id
  end

  def test_pt2
    program = Program.run(full_input)
    assert_equal 143153, program.outputs[0].value * program.outputs[1].value * program.outputs[2].value
  end

  def full_input
    File.read(File.join(__dir__, "input"))
  end

  class Program
    attr_reader :bots, :outputs
    def self.run(input)
      input.split("\n").each_with_object(Program.new) do |line, program|
        program.execute(line.strip)
      end
    end

    def initialize
      @bots = {}
      @outputs = {}
    end

    def execute(instruction)
      case instruction
      when /bot (\d+) gives low to (\w+ \d+) and high to (\w+ \d+)/
        giver_bot = bot($1.to_i)

        if $2.include?("bot")
          low_destination = bot($2.split.last.to_i)
        else
          low_destination = output($2.split.last.to_i)
        end

        if $3.include?("bot")
          high_destination = bot($3.split.last.to_i)
        else
          high_destination = output($3.split.last.to_i)
        end
        giver_bot.low_destination = low_destination
        giver_bot.high_destination = high_destination
      when /value (\d+) goes to bot (\d+)/
        bot($2.to_i).store($1.to_i)
      end
    end

    def bot(id)
      @bots[id] ||= Bot.new(id)
    end

    def output(id)
      @outputs[id] ||= Output.new(id)
    end

    def bot_for(chip1, chip2)
      bots.values.find { |bot| bot.chips.sort == [chip1, chip2].sort }
    end
  end

  class Bot
    attr_reader :id, :chips
    attr_accessor :high_destination, :low_destination
    def initialize(id)
      @id = id
      @chips = []
    end

    def store(value)
      @chips.push(value)
      distribute_chips
    end

    def high_destination=(location)
      @high_destination = location
      distribute_chips
    end

    def low_destination=(location)
      @low_destination = location
      distribute_chips
    end

    def distribute_chips
      return unless chips.length == 2
      return unless high_destination
      return unless low_destination
      high_destination.store(chips.max)
      low_destination.store(chips.min)
    end
  end

  class Output
    attr_reader :id, :value
    def initialize(id)
      @id = id
    end

    def store(value)
      @value = value
    end
  end

end
