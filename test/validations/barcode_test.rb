require 'test_helper.rb'

describe "Barcode Validation" do

  describe "EAN13 Validation" do
    
    it "accepts valid EAN13s" do
      subject = build_barcode_record :ean13, :barcode => "5023920187205"
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    describe "for invalid EAN13s" do

      it "rejects invalid EAN13s" do
        subject = build_barcode_record :ean13, :barcode => "5023920187204"
        subject.valid?.must_equal false
        subject.errors.size.must_equal 1
      end

      it "rejects EAN13s with invalid length" do
        subject = build_barcode_record :ean13, :barcode => "50239201872045879"
        subject.valid?.must_equal false
        subject.errors.size.must_equal 1
      end

      it "rejects EAN13S with invalid format" do
        subject = build_barcode_record :ean13, :barcode => "502392de872e4"
        subject.valid?.must_equal false
        subject.errors.size.must_equal 1
      end

    end

  end

  def build_barcode_record(type, attrs = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :barcode, :barcode => { :format => type }
    TestRecord.new attrs
  end
end