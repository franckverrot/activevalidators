require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

shared_examples "valid tracking number" do |tracking_number|
  it "validates" do
    subject.tracking_number = tracking_number
    subject.should be_valid
    subject.should have(0).errors
  end
end

shared_examples "invalid tracking number" do |tracking_number|
  before { subject.tracking_number = tracking_number }

  it "fails validation" do
    subject.should_not be_valid
    subject.should have(1).errors
  end

  it "has error of type 'invalid'" do
    subject.should_not be_valid
    subject.errors[:tracking_number].should include subject.errors.generate_message(:tracking_number, :invalid)
  end
end

describe "Tracking Number Validation" do

  subject { TestRecord.new }

  context "when no carrier parameter is given" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => true
    end

    it "raises an exception" do
      expect { subject.valid? }.to raise_error
    end
  end

  context "when given a ups carrier parameter" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
    end

    context 'with valid formats' do
      context 'with tracking number in 1Z................ format' do
        it_should_behave_like "valid tracking number", '1Z12345E0205271688'
      end

      context 'with tracking number in ............ format' do
        it_should_behave_like "valid tracking number", '9999V999J999'
      end

      context 'with tracking number in T.......... format' do
        it_should_behave_like "valid tracking number", 'T99F99E9999'
      end

      context 'with tracking number in ......... format' do
        it_should_behave_like "valid tracking number", '990728071'
      end
    end

    context 'with invalid formats' do
      before :each do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :tracking_number, :tracking_number => {:carrier => :ups}
      end

      context "tracking number with invalid character" do
        it_should_behave_like "invalid tracking number", '1Z12345E020_271688'
      end
    end
  end

  context "when given a usps carrier parameter" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :tracking_number, :tracking_number => {:carrier => :usps}
    end

    context "with valid formats" do
      context 'USS39 tracking number with valid MOD10 check digit' do
        it_should_behave_like "valid tracking number", 'EA123456784US'
      end

      context 'USS39 tracking number with valid MOD11 check digit' do
        it_should_behave_like "valid tracking number", 'RB123456785US'
      end

      context 'USS128 tracking number with valid MOD10 check digit' do
        it_should_behave_like "valid tracking number", '71123456789123456787'
      end
    end

    context "with invalid formats" do
      context 'USS39 tracking number with invalid check digit' do
        it_should_behave_like "invalid tracking number", 'EA123456782US'
      end

      context 'USS39 tracking number that is too short' do
        it_should_behave_like "invalid tracking number", '123456784US'
      end

      context 'USS39 tracking number that is too long' do
        it_should_behave_like "invalid tracking number", 'EAB123456784US'
      end

      context 'USS39 tracking number with non-"US" product id' do
        it_should_behave_like "invalid tracking number", 'EA123456784UT'
      end

      context 'USS128 tracking number with invalid check-digit' do
        it_should_behave_like "invalid tracking number", '71123456789123456788'
      end

      context 'USS128 tracking number that is too short' do
        it_should_behave_like "invalid tracking number", '7112345678912345678'
      end

      context 'USS128 tracking number that is too long' do
        it_should_behave_like "invalid tracking number", '711234567891234567879'
      end

      context 'USS128 tracking number with invalid chars' do
        it_should_behave_like "invalid tracking number", 'U11234567891234567879'
      end
    end
  end
end
