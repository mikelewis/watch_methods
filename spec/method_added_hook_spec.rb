require 'spec_helper'

describe "Method Added Hook" do
  context "Instance Methods" do
    before do
      if defined?(SampleObject)
        Object.send(:remove_const, :SampleObject)
      end
      SampleObject = Class.new do
        watch_for_method_added :mike, /^test_.*/, "jump" do |method|
        end
      end
    end
    it "should add a class method watch_for_method_added" do
      Module.should respond_to(:watch_for_method_added)
      SampleObject.should respond_to(:watch_for_method_added)
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

      SampleObject.class_eval { watch_for_method_added(:up) {} }

      new_hash = SampleObject.class_eval{ @method_added_watcher }

      new_hash.keys.should =~ (old_keys << "up")
    end

    it "should expand all arrays" do
      SampleObject.class_eval { watch_for_method_added ["meth1", "meth2"] {} }
      h = SampleObject.class_eval{ @method_added_watcher }
      h.each_key do |key|
        key.class.should_not == Array
      end
    end

    {:string => "my_method", :symbol => :my_method, :regex => /^my_method$/, :array => [1,2,3, "my_method"]}.each do |type, value|
      it "should call a callback when a method is added with a #{type}" do
        result = nil
        SampleObject.class_eval do
          watch_for_method_added value do |meth|
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
  end

  context "class methods" do
    if defined?(SampleObject)
      Object.send(:remove_const, :SampleClassObject)
    end
    SampleClassObject = Class.new
  end

  it "should work with eigenclass methods and eigenclass watch_for_method" do
    result = nil
    meta = class << SampleClassObject; self; end
    meta.class_eval do
      watch_for_method_added :game do |meth|
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
      watch_for_method_added :game do |meth|
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
      watch_for_method_added :game, :class_methods => true do |meth|
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
      watch_for_method_added :game, :class_methods => true do |meth|
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

end
