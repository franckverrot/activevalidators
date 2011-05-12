require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Tracking Number Validation" do

  subject { TestRecord.new }

  context "when no carrier parameter is given" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
        TestRecord.validates :tracking_number, :tracking_number => true
    end

    it "raises an exception" do
      lambda { subject.valid? }.should raise_error
    end
  end

  context "when given a ups carrier parameter" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
    end

    it 'should validate format of tracking number with 1Z################' do
      subject.tracking_number = '1Z9999999999999999'
      subject.should be_valid
      subject.should have(0).errors
    end

    it 'should validate format of tracking number with ############' do
      subject.tracking_number = '999999999999'
      subject.should be_valid
      subject.should have(0).errors
    end

    it 'should validate format of tracking number with T##########' do
      subject.tracking_number = 'T9999999999'
      subject.should be_valid
      subject.should have(0).errors
    end

    it 'should validate format of tracking number with #########' do
      subject.tracking_number = '999999999'
      subject.should be_valid
      subject.should have(0).errors
    end
  end

  describe "for invalid formats" do
    before :each do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
      subject.tracking_number = '999'
    end

    it "rejects invalid formats" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:tracking_number].should include subject.errors.generate_message(:tracking_number, :invalid)
    end
  end
end
