require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Email Validation" do
  it "accepts valid emails" do
    model = Models::EmailValidatorModel.new
    model.email = 'franck@verrot.fr'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  describe "for invalid emails" do
    let(:model) do
      Models::EmailValidatorModel.new.tap do |m|
        m.email = 'franck.fr'
      end
    end

    it "rejects invalid emails" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:email].should == [model.errors.generate_message(:email, :invalid)]
    end
  end
end
