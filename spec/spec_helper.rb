$:.unshift File.dirname(__FILE__) + '/../lib'
require 'method_added_hook'

class SampleObject
  watch_for_method_added :mike, /^test_.*/, "jump" do |method|
    puts "YUS! METHOD ADDED #{method}"
  end
end
