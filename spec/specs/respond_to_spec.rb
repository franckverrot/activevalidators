require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Respond To Validation" do
  it "respond_to?" do
    model = Models::RespondToValidatorModel.new
    model.responder = lambda {}
    model.global_condition = true
    model.local_condition = true

    model.valid?.should == true
    model.should have(0).errors
  end

  it "does not respond_to?" do
    model = Models::RespondToValidatorModel.new
    model.responder = 42
    model.global_condition = true
    model.local_condition = true

    model.valid?.should == false
    model.should have(1).errors
  end
end
