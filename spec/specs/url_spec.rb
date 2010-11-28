require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Url Validation" do
  it "accepts valid urls" do
    model = Models::UrlValidatorModel.new
    model.url = 'http://www.verrot.fr'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  it "rejected invalid urls" do
    model = Models::UrlValidatorModel.new
    model.url = 'http://^^^^.fr'
    model.valid?.should be(false)
    model.should have(1).errors
  end
end
