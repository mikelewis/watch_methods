require 'method_added_hook'

class MySimpleTest
  watch_method_added :jump do |meth|
    puts "Jump added!"
  end

  def jump

  end
end

# prints "Jump added!"
