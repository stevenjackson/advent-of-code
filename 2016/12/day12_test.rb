require 'minitest/autorun'

class Day12Test < MiniTest::Test
  def test_copy_int
    computer = Computer.new
    computer.execute("cpy 41 a")
    assert_equal 41, computer.registers["a"]
  end

  def test_copy_register
    computer = Computer.new
    computer.execute("cpy 42 a")
    computer.execute("cpy a b")
    assert_equal 42, computer.registers["b"]
  end

  def test_inc
    computer = Computer.new
    computer.execute("cpy 41 a")
    computer.execute("inc a")
    assert_equal 42, computer.registers["a"]
  end

  def test_inc_at_init
    computer = Computer.new
    computer.execute("inc d")
    assert_equal 1, computer.registers["d"]
  end

  def test_dec
    computer = Computer.new
    computer.execute("cpy 41 a")
    computer.execute("dec a")
    assert_equal 40, computer.registers["a"]
  end

  def test_dec_at_init
    computer = Computer.new
    computer.execute("dec d")
    assert_equal(-1, computer.registers["d"])
  end

  def test_jump_not_zero
    computer = Computer.new
    computer.run(["cpy 5 a", "jnz a 2", "inc a", "dec a"])
    assert_equal(4, computer.registers["a"])
  end

  def test_jnz_with_zero
    computer = Computer.new
    computer.run(["jnz a 2", "cpy 40 b", "dec b"]);
    assert_equal(39, computer.registers["b"])
  end

  def test_jnz_backwards
    computer = Computer.new
    computer.run(["cpy 5 a", "dec a", "jnz a -1"]);
    assert_equal(0, computer.registers["a"])
  end

  def test_pt1
    computer = Computer.new
    computer.run(full_input)
    assert_equal(317993, computer.registers["a"])
  end

  def test_pt2
    computer = Computer.new("c" => 1)
    computer.run(full_input)
    assert_equal(9227647, computer.registers["a"])
  end

  def full_input
    File.read(File.join __dir__, 'input').split("\n")
  end

  class Computer
    attr_reader :registers
    def initialize(initial={})
      @registers = Hash.new(0).merge(initial)
      @program_pointer = 0
    end

    def run(program)
      @program = program
      until @program_pointer >= @program.length
        next_instruction = @program[@program_pointer]
        execute(next_instruction)
        @program_pointer +=1 unless next_instruction.start_with? 'jnz'
      end

    end

    def execute(instruction)
      command, *rest = instruction.split
      case command
      when "cpy"
        copy(*rest)
      when "inc"
        increment(*rest)
      when "dec"
        decrement(*rest)
      when "jnz"
        jnz(*rest)
      end
    end

    def copy(source, dest)
      @registers[dest] = value_for(source)
    end

    def increment(register)
      @registers[register] += 1
    end

    def decrement(register)
      @registers[register] -= 1
    end

    def jnz(check_not_zero, jump_to)
      if value_for(check_not_zero) != 0
        @program_pointer += jump_to.to_i
      else
        @program_pointer += 1
      end
    end

    def value_for(input)
      @registers.key?(input) ? @registers[input] : input.to_i
    end
  end
end
