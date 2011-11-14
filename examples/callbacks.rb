require 'watch_methods'

module Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    [:after, :before].each do |action|
      define_method(action) do |*args|
        meth, opts = args
        watch_methods meth, :once => true do |m|
          register_callback(action, m, opts)
        end
      end
    end

    def register_callback(type, meth, opts={})
      alias_method :"old_#{meth}", meth
      before_proc, after_proc = [proc{}] * 2
      case type
      when :after
        after_proc = proc { send(opts[:do]) }
      when :before
        before_proc = proc { send(opts[:do]) }
      end

      define_method(meth) do |*args, &blk|
        instance_eval &before_proc
        send(:"old_#{meth}", *args, &blk)
        instance_eval &after_proc
      end
    end
  end
end

class Test
  include Callbacks
  after :jump, :do => :crawl
  before :crawl, :do => :stretch

  def jump
    puts "I'm jumpin"
  end

  def stretch
    puts "I'm stretchin"
  end

  def crawl
    puts "I'm crawlin"
  end
end


t = Test.new

t.jump

#
# prints
# I'm jumpin
# I'm stretchin
# I'm crawlin
#
