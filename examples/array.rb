require 'method_added_hook'


class ArrayTest
  watch_method_added [:sing, :dance] do |meth|
    puts "#{meth} was added!"
  end

  def dance

  end
end

#
# prints
# dance was added!
#
