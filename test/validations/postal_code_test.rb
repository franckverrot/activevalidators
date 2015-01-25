require 'test_helper'
ActiveValidators.activate(:postal_code)

describe "Postal Code Validation" do
  def build_postal_code_record postal_code, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :postal_code, :postal_code => postal_code
    TestRecord.new attrs
  end

  describe "when no country is given" do
    it 'should validate format of postal code with #####' do
      subject = build_postal_code_record true
      subject.postal_code = '11211'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it 'should validate format of postal code with #####-#####' do
      subject = build_postal_code_record true
      subject.postal_code = '94117-1234'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end
  end

  ActiveModel::Validations::PostalCodeValidator.known_formats.each do |country, formats|
    describe "when given a :#{country} country parameter" do
      formats.each do |format|
        it "should validate format of lowercase postal code with #{format}" do
          subject = build_postal_code_record :country => country
          subject.postal_code = ActiveValidators::OneNineShims::OneNineString.new(format).gsub(/[@#]/, '@' => 'A', '#' => '9')
          subject.valid?.must_equal true
          subject.errors.size.must_equal 0
        end

        it "should validate format of upcase postal code with #{format}" do
          subject = build_postal_code_record :country => country.upcase
          subject.postal_code = ActiveValidators::OneNineShims::OneNineString.new(format).gsub(/[@#]/, '@' => 'A', '#' => '9')
          subject.valid?.must_equal true
          subject.errors.size.must_equal 0
        end
      end
    end
  end


  describe "for invalid formats" do
    it "rejects invalid formats" do
      subject = build_postal_code_record true, :postal_code => '999'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      subject = build_postal_code_record true, :postal_code => '999'
      subject.valid?.must_equal false
      subject.errors[:postal_code].include?(subject.errors.generate_message(:postal_code, :invalid)).must_equal true
    end

    it "rejects injected content" do
      subject = build_postal_code_record true, :postal_code => "injected\n11211"
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end
end
