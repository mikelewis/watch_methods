require 'method_added_hook'

class ClassMethodHook
  watch_methods /crawl|jump|sit/, :class_methods => true do |meth|
    puts "#{meth} was added!"
  end

  watch_methods :smile, :class_methods => true do |meth|
    puts "Smile was added!"
  end

  class << self
    watch_methods :scream do |meth|
      puts "scream was added"
    end
  end

  def self.crawl

  end

  def self.scream

  end

  def self.jump

  end

  def self.sit

  end

  class << self
    def smile

    end
  end
end

#
# prints
# crawl was added!
# scream was added
# jump was added!
# sit was added!
# Smile was added!
#
