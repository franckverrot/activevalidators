require 'test_helper'
ActiveValidators.activate(:tracking_number)

describe "Tracking Number Validation" do
  def build_tracking_number_record carrier_opts, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :tracking_number, :tracking_number => carrier_opts
    TestRecord.new(attrs).tap do |record|
      yield record if block_given?
    end
  end

  def assert_valid_tracking_number(carrier_opts, tracking_number, &block)
    subject = build_tracking_number_record(carrier_opts, &block)
    subject.tracking_number = tracking_number
    _(subject.valid?).must_equal(true)
    _(subject.errors.size).must_equal(0)
  end

  def assert_invalid_tracking_number(carrier_opts, tracking_number, &block)
    subject = build_tracking_number_record(carrier_opts, &block)
    subject.tracking_number = tracking_number
    _(subject.valid?).must_equal(false)
    _(subject.errors.size).must_equal(1)
    _(subject.errors[:tracking_number]).must_include(subject.errors.generate_message(:tracking_number, :invalid))
  end

  describe "when no carrier parameter is given" do
    it "raises an exception" do
      assert_raises(RuntimeError, "Carrier option required") { build_tracking_number_record({:carrier=>true}).valid? }
    end
  end

  describe "when given a ups carrier parameter" do
    it 'should validate format of tracking number with 1Z................' do
      assert_valid_tracking_number({:carrier => :ups}, '1Z12345E0205271688')
    end

    it 'should validate format of tracking number with ............' do
      assert_valid_tracking_number({:carrier => :ups}, '9999V999J999')
    end

    it 'should validate format of tracking number with T..........' do
      assert_valid_tracking_number({:carrier => :ups}, 'T99F99E9999')
    end

    it 'should validate format of tracking number with .........' do
      assert_valid_tracking_number({:carrier => :ups}, '990728071')
    end

    describe "for invalid formats" do
      it "rejects invalid formats and generates an error message of type invalid" do
        assert_invalid_tracking_number({:carrier => :ups}, '1Z12345E020_271688')
      end

      it "rejects injected content" do
        assert_invalid_tracking_number({:carrier => :ups}, "injected\n1Z12345E0205271688")
      end
    end
  end

  describe "when given a usps carrier parameter" do
    describe "with valid formats" do
      it 'USS39 tracking number with valid MOD10 check digit' do
        assert_valid_tracking_number({:carrier => :usps}, 'EA123456784US')
      end

      it 'USS39 tracking number with valid MOD11 check digit' do
        assert_valid_tracking_number({:carrier => :usps}, 'RB123456785US')
      end

      it '20 character USS128 tracking number with valid MOD10 check digit' do
        assert_valid_tracking_number({:carrier => :usps}, '71123456789123456787')
      end

      it '20 character USS128 tracking number with valid MOD10 check digit ending in 0' do
        assert_valid_tracking_number({:carrier => :usps}, '03110240000115809160')
      end

      it '22 character USS128 tracking number with valid MOD10 check digit' do
        assert_valid_tracking_number({:carrier => :usps}, '9171969010756003077385')
      end
    end

    describe "with invalid formats" do
      it 'USS39 tracking number with invalid check digit' do
        assert_invalid_tracking_number({:carrier => :usps}, 'EA123456782US')
      end

      it 'USS39 tracking number that is too short' do
        assert_invalid_tracking_number({:carrier => :usps}, '123456784US')
      end

      it 'USS39 tracking number that is too long' do
        assert_invalid_tracking_number({:carrier => :usps}, 'EAB123456784US')
      end

      it 'USS39 tracking number with non-"US" product id' do
        assert_invalid_tracking_number({:carrier => :usps}, 'EA123456784UT')
      end

      it 'USS128 tracking number with invalid check-digit' do
        assert_invalid_tracking_number({:carrier => :usps}, '71123456789123456788')
      end

      it 'USS128 tracking number that is too short' do
        assert_invalid_tracking_number({:carrier => :usps}, '7112345678912345678')
      end

      it 'USS128 tracking number that is too long' do
        assert_invalid_tracking_number({:carrier => :usps}, '711234567891234567879287')
      end

      it 'USS128 tracking number with invalid chars' do
        assert_invalid_tracking_number({:carrier => :usps}, 'U11234567891234567879')
      end

      it 'rejects injected chars in USS39 and others' do
        assert_invalid_tracking_number({:carrier => :usps}, "injected\nEA123456784US")
      end
    end
  end

  describe "when given a record-based carrier parameter" do
    describe "when record gives 'ups' as carrier" do
      it 'with valid ups tracking number' do
        assert_valid_tracking_number({:carrier_field => :carrier}, '1Z12345E0205271688') do |subject|
          subject.carrier = 'ups'
        end
      end

      it 'with invalid ups tracking number' do
        assert_invalid_tracking_number({:carrier_field => :carrier}, '1Z12__5E0205271688') do |subject|
          subject.carrier = 'ups'
        end
      end
    end

    describe "when record gives 'usps' as carrier" do
      it 'with valid usps tracking number' do
        assert_valid_tracking_number({:carrier_field => :carrier}, 'EA123456784US') do |subject|
          subject.carrier = 'usps'
        end
      end

      it 'with invalid usps tracking number' do
        assert_invalid_tracking_number({:carrier_field => :carrier}, 'EA123456784UZ') do |subject|
          subject.carrier = 'usps'
        end
      end
    end

    describe "when record gives an unsupported carrier" do
      it "raises an error when validating" do
        assert_raises(RuntimeError, "Carrier option required") do
          build_tracking_number_record({:carrier=>:carrier}, :tracking_number => 'EA123456784US') do |subject|
            subject.carrier = 'fedex'
            subject.tracking_number = 'EA123456784US'
          end.valid?
        end
      end
    end
  end
end
