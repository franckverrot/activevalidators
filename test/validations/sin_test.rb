require 'test_helper'
ActiveValidators.activate(:sin)

describe "SIN validations" do
  describe "for Canada" do
    describe "for invalid" do
      it "rejects empty sin" do
        subject = build_sin_record({:sin => ''})
        subject.valid?.must_equal false
      end

      it "rejects empty sin when country is provided" do
        subject = build_sin_record({:sin => ''}, {:country => :canada })
        subject.valid?.must_equal false
      end

      it "rejects too long sin" do
        subject = build_sin_record({:sin => '123 456 789 0'}, {:country => :canada })
        subject.valid?.must_equal false
      end

      it "rejects too short sin" do
        subject = build_sin_record({:sin => '123'}, {:country => :canada })
        subject.valid?.must_equal false
      end

      it "rejects valid sin for temporary residents by default" do
        subject = build_sin_record({:sin => '996 454 286'}, {:country => :canada })
        subject.valid?.must_equal false
      end

      it "rejects invalid sin for permanent residents" do
        subject = build_sin_record({:sin => '123 456 789'}, {:country => :canada })
        subject.valid?.must_equal false
      end
    end

    describe "for valid" do
      it "accept valid sin for permanent residents without flags (Canada by default)" do
        subject = build_sin_record({:sin => '046 454 286'}, true)
        subject.valid?.must_equal true
      end

      it "accept valid sin for permanent residents" do
        subject = build_sin_record({:sin => '046 454 286'}, {:country => :canada })
        subject.valid?.must_equal true
      end

      it "accept valid sin for temporary residents when flag is provided" do
        subject = build_sin_record({:sin => '996 454 286'},
                                   {:country => :canada, :country_options => { allow_permanent_residents: true } })
        subject.valid?.must_equal true
      end
    end
  end

  def build_sin_record(attrs = {}, validator)
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :sin, :sin => validator
    TestRecord.new attrs
  end
end
