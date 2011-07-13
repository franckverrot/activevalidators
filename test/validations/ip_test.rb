require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "IP Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    @subject = TestRecord.new
  end


  describe "IPv4 Validation" do
    before :each do
      TestRecord.validates :ip, :ip => { :format => :v4 }
    end

    it "accepts valid IPs" do
      @subject.ip = '192.168.1.1'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    describe "for invalid IPs" do
      before :each do
        @subject.ip = '267.34.56.3'
      end

      it "rejects invalid IPs" do
        @subject.valid?.must_equal false
        @subject.errors.size.must_equal 1
      end

      it "generates an error message of type invalid" do
        @subject.valid?.must_equal false
        @subject.errors[:ip].include?(@subject.errors.generate_message(:ip, :invalid)).must_equal true
      end
    end
  end

  describe "IPv6 Validation" do
    before :each do
      TestRecord.validates :ip, :ip => { :format => :v6 }
    end

    it "accepts valid IPs" do
      @subject.ip = '::1'
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end

    describe "for invalid IPs" do
      before :each do
        @subject.ip = '192.168.1.1'
      end

      it "rejects invalid IPs" do
        @subject.valid?.must_equal false
        @subject.errors.size.must_equal 1
      end

      it "generates an error message of type invalid" do
        @subject.valid?.must_equal false
        @subject.errors[:ip].include?(@subject.errors.generate_message(:ip, :invalid)).must_equal true
      end
    end
  end

  it "checks validity of the arguments" do
    [3, "foo", 1..6].each do |wrong_argument|
      assert_raises(ArgumentError,"Unknown IP validator format #{wrong_argument.inspect}") do
        TestRecord.validates :ip, :ip => { :format => wrong_argument }
      end
    end
  end
end
