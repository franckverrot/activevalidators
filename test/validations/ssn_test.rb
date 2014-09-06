require 'test_helper'

describe "SSN validations" do
  describe "USA ssn" do
    describe "for invalid" do
      it "rejects empty ssn" do
        subject = build_ssn_record({:ssn => ''}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      it "rejects ssn when it doesn't consist of numbers" do
        subject = build_ssn_record({:ssn => 'aaabbcccc'}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      it "rejects ssn when the first group of digits is 000" do
        subject = build_ssn_record({:ssn => '000112222'}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      it "rejects ssn when the first group of digits is 666" do
        subject = build_ssn_record({:ssn => '666112222'}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      (900..999).each do |first_group_num|
        it "rejects ssn when the first group of digits is #{first_group_num}" do
          subject = build_ssn_record({:ssn => "#{first_group_num}112222"}, {:type => :usa_ssn})
          subject.valid?.must_equal false
        end
      end

      it "reject ssn when the second group of digits is 00" do
        subject = build_ssn_record({:ssn => "555002222"}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      it "reject ssn when the third group of digits is 0000" do
        subject = build_ssn_record({:ssn => "555660000"}, {:type => :usa_ssn})
        subject.valid?.must_equal false
      end

      (987654320..987654329).each do |reserved_ssn|
        it "rejects reserved ssn such as #{reserved_ssn}" do
          subject = build_ssn_record({:ssn => "#{reserved_ssn}"}, {:type => :usa_ssn})
          subject.valid?.must_equal false
        end
      end
    end

    describe "for valid" do
      it "accept ssn when it contains correct numbers" do
        subject = build_ssn_record({:ssn => '444556666'}, {:type => :usa_ssn})
        subject.valid?.must_equal true
      end

      it "accept ssn without type (and use by default 'usa_ssn')" do
        subject = build_ssn_record({:ssn => '444556666'}, true)
        subject.valid?.must_equal true
      end
    end
  end

  def build_ssn_record(attrs = {}, validator)
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :ssn, :ssn => validator
    TestRecord.new attrs
  end
end
