require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Respond To Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :responder, :respond_to => { :call => true, :if => :local_condition }, :if => :global_condition
  end
  
  subject { TestRecord.new }

  it "respond_to?" do
    subject.responder = lambda {}
    subject.global_condition = true
    subject.local_condition = true

    subject.should be_valid
    subject.should have(0).errors
  end

  describe "when does not respond_to?" do
    before :each do
      subject.responder        = 42
      subject.global_condition = true
      subject.local_condition  = true
    end

    it "rejects the responder" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:responder].should include subject.errors.generate_message(:responder, :invalid)
    end
  end
end
