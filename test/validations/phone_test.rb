require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Phone Validation" do

  describe "when no country is given" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :phone, :phone => true
      @subject = TestRecord.new
    end

    it 'should validate format of phone with ###-###-####' do
      @subject.phone = '999-999-9999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ##########' do
      @subject.phone = '9999999999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ###.###.####' do
      @subject.phone = '999.999.9999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with ### ### ####' do
      @subject.phone = '999 999 9999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    it 'should validate format of phone with (###) ###-####' do
      @subject.phone = '(999) 999-9999'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

  end

  ActiveModel::Validations::PhoneValidator.known_formats.each do |country, formats|
    describe "when given a :#{country} country parameter" do
      before do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :phone, :phone => {:country => country}
        @subject = TestRecord.new
      end

      formats.each do |format|
        it "should validate format of phone with #{format}" do
          @subject.phone = format.gsub('#','9')
          @subject.valid?.must_equal true
          @subject.errors.size.must_equal 0
        end
      end
    end
  end


  describe "for invalid formats" do
    before :each do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :phone, :phone => true
      @subject = TestRecord.new
      @subject.phone = '999'
    end

    it "rejects invalid formats" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:phone].include?(@subject.errors.generate_message(:phone, :invalid)).must_equal true
    end
  end
end
