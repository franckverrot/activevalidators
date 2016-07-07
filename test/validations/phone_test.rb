require 'test_helper'
ActiveValidators.activate(:phone)

describe "Phone Validation" do
  def build_phone_validation phone, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :phone, :phone => phone
    TestRecord.new attrs
  end

  describe "when a country is given" do
    it "allows numbers matching that country" do
      subject = build_phone_validation(country: :gb)
      subject.phone = '+441234567890'
      subject.valid?.must_equal true
    end

    it "does not allow numbers from other counties" do
      subject = build_phone_validation(country: :gb)
      subject.phone = '+19999999999'
      subject.valid?.must_equal false
    end
  end

  describe "when no country is given" do
    it 'should validate format of phone with ###-###-####' do
      subject = build_phone_validation true
      subject.phone = '1-999-999-9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ##########' do
      subject = build_phone_validation true
      subject.phone = '19999999999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ###.###.####' do
      subject = build_phone_validation true
      subject.phone = '1999.999.9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ### ### ####' do
      subject = build_phone_validation true
      subject.phone = '1999 999 9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with (###) ###-####' do
      subject = build_phone_validation true
      subject.phone = '1(999) 999-9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

  end


  describe "for invalid formats" do
    it "rejects invalid formats" do
      subject = build_phone_validation true
      subject.phone = '999'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      subject = build_phone_validation true
      subject.phone = '999'
      subject.valid?.must_equal false
      subject.errors[:phone].include?(subject.errors.generate_message(:phone, :invalid)).must_equal true
    end
  end
end
