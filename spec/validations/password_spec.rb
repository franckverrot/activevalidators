require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Password Validation" do
  STRENGTHS = {
    :weak   => { :valid => 'sixchr',   :invalid => 'foo' },
    :medium => { :valid => 'chrs123',  :invalid => 'sixchr' },
    :strong => { :valid => 'HQSij2323#$%', :invalid => 'chrs123' }
  }

  subject { TestRecord.new }

  STRENGTHS.each_pair do |strength, passwords|
    describe "#{strength} mode" do
      before(:each) do
        TestRecord.reset_callbacks(:validate)
        TestRecord.validates :password, :password => { :strength => strength }
      end

      describe "valid passwords" do
        it "accepts a #{strength} password like #{passwords[:valid]}" do
          subject.password = passwords[:valid]
          subject.should be_valid
          subject.should have(0).errors
        end
      end

      describe "invalid passwords" do
        before :each do
          subject.password = passwords[:invalid]
        end

        it "rejects invalid passwords like #{passwords[:invalid]}" do
          subject.should_not be_valid
          subject.should have(1).error
        end

        it "generates an error message of type invalid" do
          subject.should_not be_valid
          subject.errors[:password].should include subject.errors.generate_message(:password, :invalid)
        end
      end
    end
  end
end
