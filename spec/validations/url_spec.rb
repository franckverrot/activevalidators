require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Url Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => true
  end
  
  subject { TestRecord.new }

  it "accepts valid urls" do
    subject.url = 'http://www.verrot.fr'
    subject.should be_valid
    subject.should have(0).errors
  end

  it "accepts valid SSL urls" do
    subject.url = 'https://www.verrot.fr'
    subject.should be_valid
    subject.should have(0).errors
  end

  describe "for invalid urls" do
    before :each do
      subject.url = 'http://^^^^.fr'
    end

    it "rejects invalid urls" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:url].should include subject.errors.generate_message(:url, :invalid)
    end
  end
end
