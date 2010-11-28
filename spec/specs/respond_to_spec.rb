require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Respond To Validation" do
  it "respond_to?" do
    model = Models::RespondToValidatorModel.new
    model.responder = lambda {}
    model.global_condition = true
    model.local_condition = true

    model.valid?.should be(true)
    model.should have(0).errors
  end

  describe "when does not respond_to?" do
    let(:model) do
      Models::RespondToValidatorModel.new.tap do |m|
        m.responder        = 42
        m.global_condition = true
        m.local_condition  = true
      end
    end

    it "rejects the responder" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:responder].should == [model.errors.generate_message(:responder, :invalid)]
    end
  end
end
