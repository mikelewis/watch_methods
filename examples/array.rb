require 'method_added_hook'


class ArrayTest
  watch_methods [:sing, :dance] do |meth|
    puts "#{meth} was added!"
  end

  def dance

  end
end

#
# prints
# dance was added!
#
