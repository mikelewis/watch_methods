require 'spec_helper'

describe "Method Added Hook" do
  context "Instance Methods" do
    before do
      if defined?(SampleObject)
        Object.send(:remove_const, :SampleObject)
      end
      SampleObject = Class.new do
        watch_methods :mike, /^test_.*/, "jump" do |method|
        end
      end
    end

    it "should add a class method watch_for_method_added" do
      Module.should respond_to(:watch_methods)
      SampleObject.should respond_to(:watch_methods)
    end

    it "should create a class instance variable with the correct hash method_added_watcher" do
      h = SampleObject.class_eval{ @method_added_watcher }

      h.each_key do |key|
        key.should respond_to(:match)
      end
    end

    it "should accept being called more than once" do
      h = SampleObject.class_eval{ @method_added_watcher }
      old_keys = h.keys

      SampleObject.class_eval { watch_methods(:up) {} }

      new_hash = SampleObject.class_eval{ @method_added_watcher }

      new_hash.keys.should =~ (old_keys << "up")
    end

    it "should accept an optional parameter once and only monitor a method once" do
      result = nil
      SampleObject.class_eval do
        watch_methods(:up, :once => true) { result = 5 }

        def up

        end
      end

      result.should == 5
      result = 20

      new_hash = SampleObject.class_eval { @method_added_watcher }
      new_hash.should_not include("up")

      SampleObject.class_eval do
        def up

        end
      end

      # in other words, its not 5
      result.should == 20
    end

    it "should accept an optional parameter once and only monitor a method once (in practice)" do
      lambda {
      result = nil
      SampleObject.class_eval do
        watch_methods(:up, :once => true) do |meth|
          alias_method :"old_#{meth}", meth
          define_method(meth) {}
        end

        def up

        end
      end

      }.should_not raise_error(SystemStackError)
      # if we didn't pass in once, we would get into an infinite loop of defining a method
    end

    it "should expand all arrays" do
      SampleObject.class_eval { watch_methods ["meth1", "meth2"] {} }
      h = SampleObject.class_eval{ @method_added_watcher }
      h.each_key do |key|
        key.class.should_not == Array
      end
    end

    {:string => "my_method", :symbol => :my_method, :regex => /^my_method$/, :array => [1,2,3, "my_method"]}.each do |type, value|
      it "should call a callback when a method is added with a #{type}" do
        result = nil
        SampleObject.class_eval do
          watch_methods value do |meth|
            result = 5
          end
        end

        class SampleObject
          def my_method

          end
        end

        result.should == 5
      end
    end

    {:string => "my_method", :symbol => :my_method, :regex => /^my_method$/, :array => [1,2,3, "my_method"]}.each do |type, value|
      it "should call a callback when a method is added with a #{type} before watch_methods was called" do
        result = nil
        SampleObject.class_eval do
          def my_method

          end

          watch_methods value do |meth|
            result = 5
          end
        end

        result.should == 5
      end
    end

    it "should yield the method name (Symbol) to the block" do
      result = nil
      SampleObject.class_eval do
        watch_methods /^t.*$/ do |meth|
          result = meth
        end

        def test

        end
      end

      result.should == :test
    end

  end

  context "class methods" do
    before do
      if defined?(SampleClassObject)
        Object.send(:remove_const, :SampleClassObject)
      end
      SampleClassObject = Class.new
    end

    it "should work with eigenclass methods and eigenclass watch_methods" do
        result = nil
        meta = class << SampleClassObject; self; end
        meta.class_eval do
          watch_methods :game do |meth|
            result = 5
          end
        end

      class SampleClassObject
          class << self
            def game

            end
          end
        end

      result.should == 5
    end

    it "should work with singleton methods and eigenclass" do
      result = nil
      meta = class << SampleClassObject; self; end
      meta.class_eval do
        watch_methods :game do |meth|
          result = 5
        end
      end

      class SampleClassObject
        def self.game

        end
      end

      result.should == 5
    end

    it "should work with singleton methods and optional parameter" do
      result = nil
      SampleClassObject.class_eval do
        watch_methods :game, :class_methods => true do |meth|
          result = 5
        end
      end

      class SampleClassObject
        def self.game

        end
      end

      result.should == 5
    end

    it "should work with eigenclass methods and optional parameter" do
      result = nil
      SampleClassObject.class_eval do
        watch_methods :game, :class_methods => true do |meth|
          result = 5
        end
      end

      class SampleClassObject
        class << self
          def game

          end
        end
      end

      result.should == 5
    end

    {:string => "my_method", :symbol => :my_method, :regex => /^my_method$/, :array => [1,2,3, "my_method"]}.each do |type, value|
      it "should call a callback when a method is added with a #{type} before watch_methods was called" do
        result = nil
        SampleClassObject.class_eval do
          class << self
            def my_method

            end
          end

          watch_methods value, :class_methods => true do |meth|
            result = 5
          end
        end

        result.should == 5
      end
    end


    it "should work with an array and the optional parameter" do
      result = nil
      SampleClassObject.class_eval do
        watch_methods [:game, :test], :class_methods => true do |meth|
          result = 5
        end
      end

      class SampleClassObject
        class << self
          def test

          end
        end
      end

      result.should == 5
    end
  end

  context "Modules" do
    before do
      if defined?(SampleModuleObject)
        Object.send(:remove_const, :SampleModuleObject)
      end
      SampleModuleObject = Module.new
    end

    it "should work for an instance method" do
      result = nil
      SampleModuleObject.module_eval do
        watch_methods :hi do
          result = 5
        end
      end
      module SampleModuleObject
        def hi

        end
      end

      result.should == 5
    end

    it "should work for a singleton method" do
      result = nil
      SampleModuleObject.module_eval do
        watch_methods :hi, :class_methods => true do
          result = 5
        end
      end
      module SampleModuleObject
        def self.hi

        end
      end

      result.should == 5
    end


    it "should work for an eigenclass method" do
      result = nil
      SampleModuleObject.module_eval do
        watch_methods :hi, :class_methods => true do
          result = 5
        end
      end
      module SampleModuleObject
        class << self
          def hi

          end
        end
      end

      result.should == 5
    end

    it "should work for an eigenclass method, watched from an eigenclass" do
      result = nil
      meta = (class << SampleModuleObject; self; end)
      meta.class_eval do
        watch_methods :hi do
          result = 5
        end
      end

      module SampleModuleObject
        class << self
          def hi

          end
        end
      end

      result.should == 5
    end

    it "should work for a singleton method, watched from an eigenclass" do
      result = nil
      meta = (class << SampleModuleObject; self; end)
      meta.class_eval do
        watch_methods :hi do
          result = 5
        end
      end

      module SampleModuleObject
        def self.hi

        end
      end

      result.should == 5
    end

  end
end
