require 'method_added_hook'

class TestFramework
  def self.inherited(base)
    at_exit { instance = base.new; @tests.each{|test| instance.send(test)} }
    base.watch_method_added /^test_.+$/ do |meth|
      (@tests ||= []) << meth
    end
  end
end

class TestName < TestFramework
  def test_valid_name
    puts "Run me! test_valid_name"
  end

  def test_invalid_name
    puts "Run me! test_invalid_name"
  end

  def test_length
    puts "Run me! test_length"
  end

  def test_injections
    puts "Run me! test_injections"
  end
end

#
# prints
# Run me! test_valid_name
# Run me! test_invalid_name
# Run me! test_length
# Run me! test_injections
#
