class Module
  def watch_method_added(*watch_for, &blk)
    class_methods = false
    if watch_for.last.is_a? Hash
      opts = watch_for.pop
      class_methods = opts[:class_methods] || class_methods
    end

    context = class_methods ? (class << self; self; end) : self

    added_watcher = context.class_eval { @method_added_watcher ||= {} }

    watch_for.each do |f|
      key = case f
            when Regexp
              f
            when Symbol
              f.to_s
            when String
              f
            when Array
              f.each {|*sub_f| sub_f << opts if opts; watch_method_added(*sub_f, &blk)}
              nil
            end


      if key
        if meth = context.instance_methods(false).find{|m| key.match(m.to_s)}
          blk.call(meth)
        end
        added_watcher[key] = blk
      end
    end
  end

  def maybe_call_callback(meth, context)
    context.class_eval do
      return unless @method_added_watcher

      str_meth = meth.to_s
      if found = @method_added_watcher.find{|key,value| key.match(str_meth)}
        key, callback = found
        callback.call(meth)
      end
    end
  end

  private :maybe_call_callback

  def method_added(meth)
    maybe_call_callback(meth, self)
  end

  def singleton_method_added(meth)
    context = class << self; self; end
    maybe_call_callback(meth, context)
  end



end
