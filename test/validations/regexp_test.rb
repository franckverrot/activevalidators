require 'test_helper'
ActiveValidators.activate(:regexp)

describe "Regexp validations" do
  describe "for invalid" do
    it "rejects number" do
      subject = build_regexp_record({:regexp => 123})
      subject.valid?.must_equal false
    end

    it "rejects object" do
      subject = build_regexp_record({:regexp => Object.new})
      subject.valid?.must_equal false
    end
  end

  describe "for valid" do
    it "accept empty string" do
      subject = build_regexp_record({:regexp => ''})
      subject.valid?.must_equal true
    end

    it "accept string with some data" do
      subject = build_regexp_record({:regexp => '123'})
      subject.valid?.must_equal true
    end

    it "accept actual empty regexp" do
      subject = build_regexp_record({:regexp => //})
      subject.valid?.must_equal true
    end

    it "accept actual empty regexp" do
      subject = build_regexp_record({:regexp => /\A123\z/})
      subject.valid?.must_equal true
    end
  end

  def build_regexp_record(attrs = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :regexp, :regexp => true
    TestRecord.new attrs
  end
end