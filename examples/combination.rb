require 'method_added_hook'

class Combo
  watch_methods :test, "jump", [:cry, :dance], /^sing$/ do |meth|
    puts "#{meth} was added!"
  end

  def sing

  end

  def dance

  end

  def test

  end
end


#
# print
# sing was added!
# dance was added!
# test was added!
#
