require 'method_added_hook'

class MySimpleTest
  watch_methods :jump do |meth|
    puts "Jump added!"
  end

  def jump

  end
end

# prints "Jump added!"
