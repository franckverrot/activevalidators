require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Postal Code Validation" do

  subject { TestRecord.new }

  context "when no country is given" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :postal_code, :postal_code => true
    end

    it 'should validate format of postal code with #####' do
      subject.postal_code = '11211'
      subject.should be_valid
      subject.should have(0).errors
    end

    it 'should validate format of postal code with #####-#####' do
      subject.postal_code = '94117-1234'
      subject.should be_valid
      subject.should have(0).errors
    end
  end

  ActiveModel::Validations::PostalCodeValidator.known_formats.each do |country, formats|
    context "when given a :#{country} country parameter" do
      before(:each) do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :postal_code, :postal_code => {:country => country}
      end

      formats.each do |format|
        it "should validate format of postal code with #{format}" do
          subject.postal_code = format.gsub('#','9')
          subject.should be_valid
          subject.should have(0).errors
        end
      end
    end
  end


  describe "for invalid formats" do
    before :each do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :postal_code, :postal_code => true
      subject.postal_code = '999'
    end

    it "rejects invalid formats" do
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generates an error message of type invalid" do
      subject.should_not be_valid
      subject.errors[:postal_code].should include subject.errors.generate_message(:postal_code, :invalid)
    end
  end
end
