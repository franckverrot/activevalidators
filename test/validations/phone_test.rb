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
      _(subject.valid?).must_equal(true)
    end

    it "does not allow numbers from other countries" do
      subject = build_phone_validation(country: :gb)
      subject.phone = '+19999999999'
      _(subject.valid?).must_equal(false)
    end
  end

  describe "when no country is given" do
    it 'should validate format of phone with ###-###-####' do
      subject = build_phone_validation true
      subject.phone = '1-999-999-9999'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it 'should validate format of phone with ##########' do
      subject = build_phone_validation true
      subject.phone = '19999999999'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it 'should validate format of phone with ###.###.####' do
      subject = build_phone_validation true
      subject.phone = '1999.999.9999'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it 'should validate format of phone with ### ### ####' do
      subject = build_phone_validation true
      subject.phone = '1999 999 9999'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it 'should validate format of phone with (###) ###-####' do
      subject = build_phone_validation true
      subject.phone = '1(999) 999-9999'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

  end


  describe "for invalid formats" do
    it "rejects invalid formats" do
      subject = build_phone_validation true
      subject.phone = '999'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generates an error message of type invalid" do
      subject = build_phone_validation true
      subject.phone = '999'
      _(subject.valid?).must_equal(false)

      message = subject.errors.generate_message(:phone, :invalid)
      _(subject.errors[:phone].include?(message)).must_equal(true)
    end
  end
end
