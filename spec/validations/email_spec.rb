require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Email Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :email, :email => true
  end
  
  subject { TestRecord.new }

  it "accepts valid emails" do
    subject.email = 'franck@verrot.fr'
    subject.should be_valid
    subject.should have(0).errors
  end

  it "accepts complete emails" do
    subject.email = 'Mikel Lindsaar (My email address) <mikel@test.lindsaar.net>'
    subject.should be_valid
    subject.should have(0).errors
  end

  describe "for invalid emails" do
    before :each do
      subject.email = 'franck.fr'
    end

    it "rejects invalid emails" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it 'rejects local emails' do
      subject.email = 'franck'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:email].should include subject.errors.generate_message(:email, :invalid)
    end
  end
end
