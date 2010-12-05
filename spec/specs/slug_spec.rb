require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Slug Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :slug, :slug => true
  end
  
  subject { TestRecord.new }

  it "accepts valid slugs" do
    subject.slug = '1234567890-foo-bar-bar'
    subject.should be_valid
    subject.should have(0).errors
  end

  describe "for invalid slugs" do
    before :each do
      subject.slug = '@#$%^'
    end

    it "rejects invalid slugs" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:slug].should include subject.errors.generate_message(:slug, :invalid)
    end
  end
end
