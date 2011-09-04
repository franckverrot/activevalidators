require 'test_helper.rb'

describe "IP Validation" do
  describe "IPv4 Validation" do
    it "accepts valid IPs" do
      subject = build_ip_record :v4, :ip => '192.168.1.1'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    describe "for invalid IPs" do
      it "rejects invalid IPs" do
        subject = build_ip_record :v4, :ip => '267.34.56.3'
        subject.valid?.must_equal false
        subject.errors.size.must_equal 1
      end

      it "generates an error message of type invalid" do
        subject = build_ip_record  :v4, :ip => '267.34.56.3'
        subject.valid?.must_equal false
        subject.errors[:ip].include?(subject.errors.generate_message(:ip, :invalid)).must_equal true
      end
    end
  end

  describe "IPv6 Validation" do
    it "accepts valid IPs" do
      subject = build_ip_record :v6, :ip => '::1'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    describe "for invalid IPs" do
      it "rejects invalid IPs" do
        subject = build_ip_record :v6, :ip => '192.168.1.1'
        subject.valid?.must_equal false
        subject.errors.size.must_equal 1
      end

      it "generates an error message of type invalid" do
        subject = build_ip_record :v6, :ip => '192.168.1.1'
        subject.valid?.must_equal false
        subject.errors[:ip].include?(subject.errors.generate_message(:ip, :invalid)).must_equal true
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

  def build_ip_record(version, attrs = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :ip, :ip => { :format => version }
    TestRecord.new attrs
  end
end
