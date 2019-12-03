require 'minitest/autorun'

class Day7Test < MiniTest::Test
  def test_has_abba
    ip = IP.new("abba[mnop]qrst")

    assert ip.find_abbas.any?
  end

  def test_hypernet_abba_does_not_support_tls
    input = "abcd[bddb]xyyx"
    ip = IP.new(input)
    assert_equal false, ip.tls?
  end

  def test_multi_hypernet
    input = "abcd[biaa]xyyx[foof]hey"
    ip = IP.new(input)
    assert_equal false, ip.tls?
  end

  def test_same_character_does_not_support_tls
    ip = IP.new("aaaa[qwer]tyui")
    assert_equal false, ip.tls?
  end

  def test_tls
    ip = IP.new("ioxxoj[asdfgh]zxcvbn")
    assert_equal true, ip.tls?
  end

  def test_pt1
    tls_ips = full_input.select { |line| IP.new(line).tls? }
    assert_equal 110, tls_ips.count
  end

  def full_input
    File.read(File.join(__dir__, 'input')).split("\n")
  end

  def test_aba
    ip = IP.new("cdc[stuff]")
    assert_equal "cdc", ip.find_abas.first
  end

  def test_aba_in_hypernet_not_ssl
    ip = IP.new("abc[cdc]")
    assert_equal false, ip.ssl?
  end

  def test_aba_bab_for_ssl
    ip = IP.new("cdc[dcd]")
    assert_equal true, ip.ssl?
  end

  def test_pt2
    ssl_ips = full_input.select { |line| IP.new(line).ssl? }
    assert_equal 242, ssl_ips.count
  end

  class IP
    def initialize(ip)
      @ip = ip
    end

    def find_abbas(input=@ip)
      found = []
      input.chars.each_with_index do |c, i|
        next if i == 0
        next_seq = input.slice(i-1, 4)
        found << next_seq if abba_seq?(next_seq)
      end
      found
    end

    def find_abas(input=@ip)
      found = []
      input.chars.each_with_index do |c, i|
        next if i == 0
        next_seq = input.slice(i-1, 3)
        found << next_seq if aba_seq?(next_seq)
      end
      found
    end

    def find_babs(input=@ip)
      found = []
      input.chars.each_with_index do |c, i|
        next if i == 0
        next_seq = input.slice(i-1, 3)
        found << next_seq if bab_seq?(next_seq)
      end
      found
    end

    def aba_seq?(word)
      word[0] == word[2] && word[0] != word[1]
    end

    def abba_seq?(word)
      word[0] == word[3] && word[1] == word[2] && word[0] != word[1]
    end

    def supernet
      supernet_parts = @ip.dup
      hypernet.each { |hypernet| supernet_parts.gsub!(hypernet, '---') }
      supernet_parts.split '---'
    end

    def hypernet
      @ip.scan(/\[.*?\]/)
    end

    def tls?
      return false if find_abbas(hypernet.join("|")).any?
      find_abbas(supernet.join("|")).any?
    end

    def ssl?
      abas = find_abas(supernet.join("|"))
      abas.select do |aba|
        bab = aba[1] + aba[0] + aba[1]
        hypernet.join.include? bab
      end.any?
    end
  end

end
