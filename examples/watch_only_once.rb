require 'method_added_hook'


class ManyDeclarations
  watch_methods :test, :once => true do |meth|
    puts "test was added!"
  end

  100.times do
    define_method :test do

    end
  end
end

# prints test was added! only once
