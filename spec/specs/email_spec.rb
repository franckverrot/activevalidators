require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Email Validation" do
  it "accepts valid emails" do
    model = Models::EmailValidatorModel.new
    model.email = 'franck@verrot.fr'
    model.valid?.should == true
    model.should have(0).errors
  end

  it "rejected invalid emails" do
    model = Models::EmailValidatorModel.new
    model.email = 'franck.fr'
    model.valid?.should == false
    model.should have(1).errors
  end
end
