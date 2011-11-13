require 'method_added_hook'

module Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    [:after, :before].each do |action|
      define_method(action) do |meth, opts={}|
        watch_method_added meth, :once => true do |m|
        puts meth
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
        before_proc.call
        send(:"old_#{meth}", *args, &blk)
        after_proc.call
      end
    end
  end
end

class Test
  include Callbacks
  after :jump, :do => :crawl

  def jump

  end
end
