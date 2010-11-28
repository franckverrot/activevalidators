require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Phone Validation" do

  it 'should validate format of phone with ###-###-####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999-999-9999'
    model.valid?.should == true
    model.should have(0).errors
  end

  it 'should validate format of phone with ##########' do
    model = Models::PhoneValidatorModel.new
    model.phone = '9999999999'
    model.valid?.should == true
    model.should have(0).errors
  end

  it 'should validate format of phone with ###.###.####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999.999.9999'
    model.valid?.should == true
    model.should have(0).errors
  end

  it 'should validate format of phone with ### ### ####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999 999 9999'
    model.valid?.should == true
    model.should have(0).errors
  end

  it 'should validate format of phone with (###) ###-####' do
    model = Models::PhoneValidatorModel.new
    model.phone = '(999) 999-9999'
    model.valid?.should == true
    model.should have(0).errors
  end
  
  it 'should validate format of phone' do
    model = Models::PhoneValidatorModel.new
    model.phone = '999'
    model.valid?.should == false
    model.should have(1).errors
  end

end
