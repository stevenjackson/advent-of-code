require 'minitest/autorun'
class Day4Test < MiniTest::Test
  def test_real_room
    room = RoomLocation.new("aaaaa-bbb-z-y-x", nil, "abxyz")
    assert room.real?
  end

  def test_parser
    room = RoomLocation.parse "aaaaa-bbb-z-y-x-123[abxyz]"
    assert_equal "aaaaa-bbb-z-y-x", room.name
    assert_equal 123, room.sector_id
    assert_equal "abxyz", room.checksum
  end

  def test_pt_1
    real_sector_ids = real_rooms.map(&:sector_id)
    sum = real_sector_ids.reduce(:+)
    assert_equal 245102, sum
  end

  def test_pt2
    target = real_rooms.find do |room|
      room.decrypt_name == "northpole object storage"
    end
    assert_equal 324, target.sector_id
  end

  def test_shift
    room = RoomLocation.new("qzmt-zixmtkozy-ivhz", 343)
    assert_equal "very encrypted name", room.decrypt_name
  end

  def real_rooms
    full_input = File.read(File.join(__dir__, 'input'))
    rooms = full_input.split("\n").map { |line| RoomLocation.parse(line) }
    rooms.select(&:real?)
  end

  class RoomLocation
    def self.parse(input)
      room_id, checksum = input.split("[")
      room_id_parts = room_id.split("-")
      sector_id = room_id_parts.slice!(-1)
      room_name = room_id_parts.join("-")
      checksum.chop!
      RoomLocation.new(room_name, sector_id.to_i, checksum)
    end

    attr_reader :name, :sector_id, :checksum
    def initialize(room_name, sector_id, checksum=nil)
      @name = room_name
      @sector_id = sector_id
      @checksum = checksum
    end

    def real?
      calculate_checksum(name) == self.checksum
    end

    def decrypt_name
      name.chars.map { |c| decrypt_char(c) }.join
    end

    def decrypt_char(c)
      return ' ' if c == '-'
      chars_to_move = sector_id % 26
      alphabet = ("a".."z").to_a
      index = alphabet.index(c) + chars_to_move
      index = (index - 26) if index > 25
      alphabet[index]
    end

    def calculate_checksum(room_name)
      groups = room_name.tr('-', '').chars.group_by { |c| c }.values
      groups = groups.sort do |a1, a2|
        diff = a2.length - a1.length
        if diff == 0
          diff = a1.first.ord - a2.first.ord
        end
        diff
      end
      groups.map(&:first).join.slice(0, 5);
    end
  end
end
