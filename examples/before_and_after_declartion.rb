require 'watch_methods'

class BeforeAndAfter
  watch_methods :yo do |meth|
    puts "yo was added!"
  end

  def yo

  end

  def hey

  end

  watch_methods :hey do |meth|
    puts "Hey was added!"
  end
end

#
# Prints
# yo was added!
# Hey was added!
#
