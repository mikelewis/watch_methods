require 'method_added_hook'

class BeforeAndAfter
  watch_method_added :yo do |meth|
    puts "yo was added!"
  end

  def yo

  end

  def hey

  end

  watch_method_added :hey do |meth|
    puts "Hey was added!"
  end
end

#
# Prints
# yo was added!
# Hey was added!
#
