watch_methods
=============

## What is this thing?

  Monitor when methods are added to classes or modules and take action when they do.

## Why would I want this?
  You are:

  - developing a kick-ass gem and you want your users to use your class methods before methods are actually defined (think AR validators, callback etc.)
  - Want to monitor all methods starting with queue_ for your new awesome queueing gem.
  - and more!

##Install

    [sudo] gem install method_added_hook


### Skip all the crap, give me the examples.
   [Examples](https://github.com/mikelewis/watch_methods/tree/master/examples)

##Usage
   The method that you'll be interacting with is the `watch_methods` method that is defined as:

    watch_methods(methods, opts={}, &blk)

   Where:

   - methods can be a symbol, string, array, regex or any combination. This will be all the methods you want to monitor.

   - opts currently has two optional parameters `:class_methods` to watch for class methods and `:once` to
   only run the given block once for a given method.

   - a given block, which will get run after a given method to watch was added.

Here are some valid uses of `watch_methods`:

    watch_methods(:special_func1, :special_func2) do |meth|

    end


    # this will watch any class method starting with test_, queue_
    watch_methods(/^test_.+$/, /^queue_.+$/, :class _methods => true) do |meth|

    end

    watch_methods([:meth_one, :meth_two]) do |meth|

     end

  or a combination of all of the above:

    watch_methods(:special_func, /^test_meth$/, [:meth1, :meth2]) do |meth|

    end

  To see all examples/cases, see the examples directory and the spec file.

###Supports
  Ruby 1.8.7, 1.9.2, 1.9.3

