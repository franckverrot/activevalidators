require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "IP Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
  end
  
  subject { TestRecord.new }

  describe "IPv4 Validation" do
    before :each do
      TestRecord.validates :ip, :ip => { :format => :v4 }
    end

    it "accepts valid IPs" do
      subject.ip = '192.168.1.1'
      subject.should be_valid
      subject.should have(0).errors
    end

    context "for invalid IPs" do
      before :each do
        subject.ip = '267.34.56.3'
      end

      it "rejects invalid IPs" do
        subject.should_not be_valid
        subject.should have(1).error
      end

      it "generates an error message of type invalid" do
        subject.should_not be_valid
        subject.errors[:ip].should include subject.errors.generate_message(:ip, :invalid)
      end
    end
  end

  describe "IPv6 Validation" do
    before :each do
      TestRecord.validates :ip, :ip => { :format => :v6 }
    end

    it "accepts valid IPs" do
      subject.ip = '::1'
      subject.should be_valid
      subject.should have(0).errors
    end

    context "for invalid IPs" do
      before :each do
        subject.ip = '192.168.1.1'
      end

      it "rejects invalid IPs" do
        subject.should_not be_valid
        subject.should have(1).error
      end

      it "generates an error message of type invalid" do
        subject.should_not be_valid
        subject.errors[:ip].should include subject.errors.generate_message(:ip, :invalid)
      end
    end
  end

  it "checks validity of the arguments" do
    [3, "foo", 1..6].each do |wrong_argument|
      expect {
        TestRecord.validates :ip, :ip => { :format => wrong_argument }
      }.to raise_error(ArgumentError, "Unknown IP validator format #{wrong_argument.inspect}")
    end
  end
end
