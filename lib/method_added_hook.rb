class Module

  def watch_for_method_added(*watch_for, &blk)
    @method_added_watcher ||= {}
    watch_for.each do |f|

      key = case f
            when Regexp
              f
            when Symbol
              f.to_s
            when String
              f
            when Array
              f.each {|sub_f| watch_for_method_added(sub_f, &blk)}
              nil
            end
      @method_added_watcher[key] = blk if key
    end
  end
end
