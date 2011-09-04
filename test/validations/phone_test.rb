require 'test_helper.rb'

describe "Phone Validation" do
  def build_phone_validation phone, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :phone, :phone => phone
    TestRecord.new attrs
  end


  describe "when no country is given" do
    it 'should validate format of phone with ###-###-####' do
      subject = build_phone_validation true
      subject.phone = '999-999-9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ##########' do
      subject = build_phone_validation true
      subject.phone = '9999999999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ###.###.####' do
      subject = build_phone_validation true
      subject.phone = '999.999.9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ### ### ####' do
      subject = build_phone_validation true
      subject.phone = '999 999 9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with (###) ###-####' do
      subject = build_phone_validation true
      subject.phone = '(999) 999-9999'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

  end

  ActiveModel::Validations::PhoneValidator.known_formats.each do |country, formats|
    describe "when given a :#{country} country parameter" do
      formats.each do |format|
        it "should validate format of phone with #{format}" do
          subject = build_phone_validation :country => country
          subject.phone = format.gsub('#','9')
          subject.valid?.must_equal true
          subject.errors.size.must_equal 0
        end
      end
    end
  end


  describe "for invalid formats" do
    it "rejects invalid formats" do
      subject = build_phone_validation true, :phone => '999'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      subject = build_phone_validation true, :phone => '999'
      subject.valid?.must_equal false
      subject.errors[:phone].include?(subject.errors.generate_message(:phone, :invalid)).must_equal true
    end
  end
end
