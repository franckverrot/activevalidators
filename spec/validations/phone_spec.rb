require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Phone Validation" do

  subject { TestRecord.new }

  context "when no country is given" do
    before(:each) do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :phone, :phone => true
    end

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

  end

  ActiveModel::Validations::PhoneValidator.known_formats.each do |country, formats|
    context "when given a :#{country} country parameter" do
      before(:each) do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :phone, :phone => {:country => country}
      end

      formats.each do |format|
        it "should validate format of phone with #{format}" do
          subject.phone = format.gsub('#','9')
          subject.should be_valid
          subject.should have(0).errors
        end
      end
    end
  end


  describe "for invalid formats" do
    before :each do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :phone, :phone => true
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
