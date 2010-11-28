require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Phone Validation" do

  it 'should validate format of phone with ###-###-####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999-999-9999'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  it 'should validate format of phone with ##########' do
    model = Models::PhoneValidatorModel.new
    model.phone = '9999999999'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  it 'should validate format of phone with ###.###.####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999.999.9999'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  it 'should validate format of phone with ### ### ####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999 999 9999'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  it 'should validate format of phone with (###) ###-####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '(999) 999-9999'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  describe "for invalid formats" do
    let(:model) do
      Models::PhoneValidatorModel.new.tap do |m|
        m.phone = '999'
      end
    end

    it "rejects invalid formats" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:phone].should == [model.errors.generate_message(:phone, :invalid)]
    end
  end
end
