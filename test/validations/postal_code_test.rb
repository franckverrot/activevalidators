require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Postal Code Validation" do

  describe "when no country is given" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :postal_code, :postal_code => true
      @subject = TestRecord.new
    end

    it 'should validate format of postal code with #####' do
      @subject.postal_code = '11211'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of postal code with #####-#####' do
      @subject.postal_code = '94117-1234'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end
  end

  ActiveModel::Validations::PostalCodeValidator.known_formats.each do |country, formats|
    describe "when given a :#{country} country parameter" do
      before do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :postal_code, :postal_code => {:country => country}
        @subject = TestRecord.new
      end

      formats.each do |format|
        it "should validate format of postal code with #{format}" do
          @subject.postal_code = format.gsub('#','9')
          @subject.valid?.must_equal true
          @subject.errors.size.must_equal 0
        end
      end
    end
  end


  describe "for invalid formats" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :postal_code, :postal_code => true
      @subject = TestRecord.new
      @subject.postal_code = '999'
    end

    it "rejects invalid formats" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:postal_code].include?(@subject.errors.generate_message(:postal_code, :invalid)).must_equal true
    end
  end
end
