require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Phone Validation" do

  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :phone, :phone => true
  end
  
  subject { TestRecord.new }

  it 'should validate format of phone with ###-###-####' do
    subject.phone = '999-999-9999'
    subject.should be_valid
    subject.should have(0).errors
  end

  it 'should validate format of phone with ##########' do
    subject.phone = '9999999999'
    subject.should be_valid
    subject.should have(0).errors
  end

  it 'should validate format of phone with ###.###.####' do
    subject.phone = '999.999.9999'
    subject.should be_valid
    subject.should have(0).errors
  end

  it 'should validate format of phone with ### ### ####' do
    subject.phone = '999 999 9999'
    subject.should be_valid
    subject.should have(0).errors
  end

  it 'should validate format of phone with (###) ###-####' do
    subject.phone = '(999) 999-9999'
    subject.should be_valid
    subject.should have(0).errors
  end

  describe "for invalid formats" do
    before :each do
      subject.phone = '999'
    end

    it "rejects invalid formats" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:phone].should include subject.errors.generate_message(:phone, :invalid)
    end
  end
end
