require 'minitest/autorun'
class Day5Test < MiniTest::Test

  def test_pt1
    input = "ojvtpuvg"
    index = 0
    matches = []
    while matches.length < 8
      hash = md5(input, index += 1)
      if hash.start_with? "00000"
        matches << hash
      end
    end
    password = matches.map do |match|
      match[5]
    end.join
    assert_equal "4543c154", password
  end

  def test_pt2
    input = "ojvtpuvg"
    index = 0
    password = "--------"
    while password.include? '-'
      hash = md5(input, index += 1)
      if hash.start_with? "00000"
        position = hash[5]
        position = position.to_i if position =~ /[0-7]/
        code = hash[6]
        if password[position] && password[position] == '-'
          password[position] = code
        end
      end
    end
    assert_equal "1050cbbd", password
  end

  def md5(input, index)
    Digest::MD5.hexdigest(input + index.to_s)
  end
end
