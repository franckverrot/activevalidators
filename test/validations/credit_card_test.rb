require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Credit Card Validation" do
  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :card,  :credit_card => { :type => :any }
    @subject = TestRecord.new
  end


  # Here are some valid credit cards
  VALID_CARDS =  
  {
    #American Express
    :amex =>	'3400 0000 0000 009',
    #Carte Blanche	
    :carte_blanche => '3000 0000 0000 04',
    #Discover	
    :discover => '6011 0000 0000 0004',
    #Diners Club	
    :diners_club => '3852 0000 0232 37',
    #enRoute	
    :en_route => '2014 0000 0000 009',
    #JCB	
    :jcb => '2131 0000 0000 0008',
    #MasterCard	
    :master_card => '5500 0000 0000 0004',
    #Solo	
    :solo => '6334 0000 0000 0004',
    #Switch	
    :switch => '4903 0100 0000 0009',
    #Visa	
    :visa => '4111 1111 1111 1111',
    #Laser	
    :laser => '6304 1000 0000 0008'
  }

  VALID_CARDS.each_pair do |card, number|
    it "accepts #{card} valid cards" do
      @subject.card = number
      @subject.valid?.must_equal true
      @subject.errors.size.must_equal 0
    end
  end

  describe "for invalid cards" do

    before :each do
      @subject.card = '99999'
    end

    it "rejects invalid cards" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:card].include?(@subject.errors.generate_message(:card, :invalid)).must_equal true
    end
  end
end
