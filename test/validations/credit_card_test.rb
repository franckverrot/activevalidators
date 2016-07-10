require 'test_helper'
ActiveValidators.activate(:credit_card)

describe "Credit Card Validation" do
  # Here are some valid credit cards
  VALID_CARDS =
      {
          #American Express
          :amex => '3400 0000 0000 009',
          #Discover
          :discover => '6011 0000 0000 0004',
          #Diners Club
          :diners_club => '3852 0000 0232 37',
          #JCB
          :jcb => '3530 1113 3330 0000',
          #MasterCard
          :master_card => '5500 0000 0000 0004',

          :mastercard => '5500 0000 0000 0004',
          #Solo
          :solo => '6334 0000 0000 0004',
          #maestro
          :maestro => '6759 6498 2643 8453',
          #Visa
          :visa => '4111 1111 1111 1111',
      }

  VALID_CARDS.each_pair do |card, number|
    describe "it accepts #{card} cards" do
      it "using a specific card type" do
        subject = build_card_record({:card => number}, {:type => card})
        assert card_is_valid?(subject)
      end
      it "using :credit_card => { :type => :any }" do
        subject = build_card_record({:card => number}, {:type => :any})
        assert card_is_valid?(subject)
      end
      it "using :credit_card => true" do
        subject = build_card_record({:card => number}, true)
        assert card_is_valid?(subject)
      end
    end
  end

  describe "carte blanche" do
    it "is deprecated" do
      subject = build_card_record(
        { card: '3800 0000 0000 06' },
        { type: :carte_blanche },
      )
      assert_deprecated do
        card_is_valid?(subject)
      end
    end
  end

  describe "using multiple card types" do
    it "accepts card if one of type valid" do
      subject = build_card_record({:card => VALID_CARDS[:amex]}, {:type => [:visa, :master_card, :amex]})
      assert card_is_valid?(subject)
    end

    it "rejects card if none of type valid" do
      subject = build_card_record({:card => VALID_CARDS[:solo]}, {:type => [:visa, :master_card, :amex]})
      assert card_is_invalid?(subject)
    end
  end
  describe "for invalid cards" do
    it "rejects invalid cards and generates an error message of type invalid" do
      subject = build_card_record :card => '99999'
      assert card_is_invalid?(subject)
    end
  end

  def build_card_record(attrs = {}, validator = {:type => :any})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :card, :credit_card => validator
    TestRecord.new attrs
  end

  def card_is_valid?(subject)
    subject.valid?.must_equal true
    subject.errors.size.must_equal 0
  end

  def card_is_invalid?(subject)
    subject.valid?.must_equal false
    subject.errors.size.must_equal 1
    subject.errors[:card].include?(subject.errors.generate_message(:card, :invalid)).must_equal true
  end

end
