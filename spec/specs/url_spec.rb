require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Url Validation" do
  it "accepts valid urls" do
    model = Models::UrlValidatorModel.new
    model.url = 'http://www.verrot.fr'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  describe "for invalid emails" do
    let(:model) do
      Models::UrlValidatorModel.new.tap do |m|
        m.url = 'http://^^^^.fr'
      end
    end

    it "rejects invalid emails" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:url].should == [model.errors.generate_message(:url, :invalid)]
    end
  end
end
