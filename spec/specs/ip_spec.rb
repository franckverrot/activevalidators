require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "IP Validation" do
  describe "IPv4 Validation" do
    it "accepts valid IPs" do
      model = Models::IpValidatorModel.new
      model.ipv4 = '192.168.1.1'
      model.valid?.should be(true)
      model.should have(0).errors
    end

    describe "for invalid IPs" do
      let(:model) do
        Models::IpValidatorModel.new.tap do |m|
          m.ipv4 = '267.34.56.3'
        end
      end

      it "rejects invalid IPs" do
        model.should_not be_valid
        model.should have(1).errors
      end

      it "generates an error message of type invalid" do
        model.should_not be_valid
        model.errors[:ipv4].should == [model.errors.generate_message(:ipv4, :invalid)]
      end
    end
  end

  describe "IPv6 Validation" do
    it "accepts valid IPs" do
      model = Models::IpValidatorModel.new
      model.ipv6 = '::1'
      model.valid?.should be(true)
      model.should have(0).errors
    end

    describe "for invalid IPs" do
      let(:model) do
        Models::IpValidatorModel.new.tap do |m|
          m.ipv6 = '192.168.1.1'
        end
      end

      it "rejects invalid IPs" do
        model.valid?.should be(false)
        model.should have(1).errors
      end

      it "generates an error message of type invalid" do
        model.valid?.should be(false)
        model.errors[:ipv6].should == [model.errors.generate_message(:ipv6, :invalid)]
      end
    end
  end
end
