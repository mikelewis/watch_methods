require 'method_added_hook'

class Queues
  watch_method_added /^queue_(.+)$/ do |meth|
    puts "Queue #{meth} was added!"
  end

  def queue_jump

  end

  def queue_smile

  end
end

#
#prints
# Queue queue_jump was added!
# Queue queue_smile was added!
#
