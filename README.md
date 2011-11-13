method_added hook
=============

#Problem

Developing an API that involves monitoring/editing a method like this is quite annoying as you need to have your users put your class_method call after the method declaration like so:

    class A

       def print_stuff
         puts "hi"
       end

       do_work_on :print_stuff


       def jump
         puts "jumping"
       end

       do_work_on :jump


       def crawl
         puts "crawl"
       end

       do_work_on :crawl
    end

Wouldn't it be nice to allow your users to mention methods before they are declared like this?:


    class A

       do_work_on :print_stuff
       do_work_on :crawl
       do_work_on :jump

       # or do_work_on :print_stuff, :crawl, :jump

       def print_stuff
         puts "hi"
       end

       def jump
         puts "jumping"
       end

       def crawl
         puts "crawl"
       end
    end


But if your method was defined like this:

    def do_work_on(*meths)
      meths.each do |meth|
        alias_method "old_meth_#{meth}", meth
      end
    end

It will throw an exception as you haven't defined that method yet.

#Solution

##Install

    [sudo] gem install method_added_hook


##Usage
   The method that you'll be interacting with is the `watch_method_added` method that is defined as:

    watch_method_added(methods, opts={}, &blk)

   Where methods can be a symbol, string, array, regex or any combination, opts currently has one optional parameter `:class_methods` to watch for class methods and a given block, which will get run after a given method to watch was added.

 Here are some valid uses of `watch_method_added`:

    watch_method_added(:special_func1, :special_func2) do |meth|

    end


    # this will watch any class method starting with test_, queue_
    watch_method_added(/^test_.+$/, /^queue_.+$/, :class _methods => true) do |meth|

    end

    watch_method_added([:meth_one, :meth_two]) do |meth|

    end

  or a combination of all of the above:

    watch_method_added(:special_func, /^test_meth$/, [:meth1, :meth2]) do |meth|

    end

So to solve the problem we mentioned above, you can do this:

    def do_work_on(*meths)
       watch_method_added(meths) do |meth|
        alias_method "old_meth_#{meth}", meth
      end
    end

But what if you want to support `do_work_on` after method declaration? No problem! `watch_method_added` knows if a method that you want to watch was already added.

  To see all examples/cases, see the examples directory and the spec file.

