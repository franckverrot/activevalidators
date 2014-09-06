require 'test_helper'
ActiveValidators.activate(:password)

describe "Password Validation" do
  STRENGTHS = {
    :weak   => { :valid => 'sixchr',   :invalid => 'foo' },
    :medium => { :valid => 'chrs123',  :invalid => 'sixchr' },
    :strong => { :valid => 'HQSij2323#$%', :invalid => 'chrs123' }
  }

  STRENGTHS.each_pair do |strength, passwords|
    describe "#{strength} mode" do
      describe "valid passwords" do
        it "accepts a #{strength} password like #{passwords[:valid]}" do
          subject = build_password_record strength, :password => passwords[:valid]
          subject.valid?.must_equal true
          subject.errors.size.must_equal 0
        end
      end

      describe "invalid passwords" do
        it "rejects invalid passwords like #{passwords[:invalid]}" do
          subject = build_password_record strength, :password => passwords[:invalid]
          subject.valid?.must_equal false
          subject.errors.size.must_equal 1
        end

        it "generates an error message of type invalid" do
          subject = build_password_record strength, :password => passwords[:invalid]
          subject.valid?.must_equal false
          subject.errors[:password].include?(subject.errors.generate_message(:password, :invalid)).must_equal true
        end
      end
    end
  end
  def build_password_record(strength, attrs = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :password, :password => { :strength => strength }
    TestRecord.new attrs
  end
end
