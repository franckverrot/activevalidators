require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

# Here are some valid credit cards
CARDS = {
  #American Express
  :amex =>	'3400 0000 0000 009',
  #MasterCard	
  :master_card => '5500 0000 0000 0004',
  #Switch	
  :switch => '4903 0100 0000 0009',
  #Visa	
  :visa => '4111 1111 1111 1111',
}

describe "Credit Card Validation" do
  CARDS.each_pair do |card, number|
  it "accepts #{card} valid cards" do
    model = Models::CreditCardValidatorModel.new
    model.card = number
    model.valid?.should be(true)
    model.should have(0).errors
  end
  end

  describe "for invalid cards" do
    let(:model) do
      Models::CreditCardValidatorModel.new.tap do |m|
        m.card = '99999'
      end
    end

    it "rejects invalid cards" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:card].should == [model.errors.generate_message(:card, :invalid)]
    end
  end
end
