require 'watch_methods'

class Queues
  watch_methods /^queue_(.+)$/ do |meth|
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
