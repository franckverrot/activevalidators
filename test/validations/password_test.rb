require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Password Validation" do
  STRENGTHS = {
    :weak   => { :valid => 'sixchr',   :invalid => 'foo' },
    :medium => { :valid => 'chrs123',  :invalid => 'sixchr' },
    :strong => { :valid => 'HQSij2323#$%', :invalid => 'chrs123' }
  }

  STRENGTHS.each_pair do |strength, passwords|
    describe "#{strength} mode" do
      before(:each) do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :password, :password => { :strength => strength }
        @subject = TestRecord.new
      end

      describe "valid passwords" do
        it "accepts a #{strength} password like #{passwords[:valid]}" do
          @subject.password = passwords[:valid]
          @subject.valid?.must_equal true
          @subject.errors.size.must_equal 0
        end
      end

      describe "invalid passwords" do
        before :each do
          @subject.password = passwords[:invalid]
        end

        it "rejects invalid passwords like #{passwords[:invalid]}" do
          @subject.valid?.must_equal false
          @subject.errors.size.must_equal 1
        end

        it "generates an error message of type invalid" do
          @subject.valid?.must_equal false
          @subject.errors[:password].include?(@subject.errors.generate_message(:password, :invalid)).must_equal true
        end
      end
    end
  end
end
