require 'spec_helper'

describe "Method Added Hook" do
  it "should add a class method watch_for_method_added" do
    Module.should respond_to(:watch_for_method_added)
    SampleObject.should respond_to(:watch_for_method_added)

    puts SampleObject.class_eval { @method_added_hook }
  end

end
