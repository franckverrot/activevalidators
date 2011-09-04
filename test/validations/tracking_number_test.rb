require 'test_helper.rb'

describe "Tracking Number Validation" do

  describe "when no carrier parameter is given" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => true
      @subject = TestRecord.new
    end

    it "raises an exception" do
      assert_raises(RuntimeError, "Carrier option required") { @subject.valid? }
    end
  end

  describe "when given a ups carrier parameter" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
      @subject = TestRecord.new
    end

    it 'should validate format of tracking number with 1Z................' do
      @subject.tracking_number = '1Z12345E0205271688'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of tracking number with ............' do
      @subject.tracking_number = '9999V999J999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of tracking number with T..........' do
      @subject.tracking_number = 'T99F99E9999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of tracking number with .........' do
      @subject.tracking_number = '990728071'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end
  end

  describe "for invalid formats" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
      @subject = TestRecord.new
      @subject.tracking_number = '1Z12345E020_271688'
    end

    it "rejects invalid formats" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:tracking_number].include?(@subject.errors.generate_message(:tracking_number, :invalid)).must_equal true
    end
  end
end
