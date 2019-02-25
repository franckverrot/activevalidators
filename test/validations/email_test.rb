require 'test_helper'
ActiveValidators.activate(:email)

describe "Email Validation" do
  describe "strict: true" do

    it "accepts valid emails" do
      subject = build_email_record({:email => 'franck@verrot.fr'}, {:strict => true})
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts valid emails" do
      subject = build_email_record({:email => 'franck@edu.verrot-gouv.fr'}, {:strict => true})
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts complete emails" do
      subject = build_email_record({:email => 'Mikel Lindsaar (My email address) <mikel@test.lindsaar.net>'}, {:strict => true})
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts email addresses without TLD" do
      subject = build_email_record({:email => 'franck@verrotfr'}, {:strict => true})
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end

  describe "strict: false (default)" do
    it "accepts valid emails" do
      subject = build_email_record :email => 'franck@verrot.fr'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts valid emails" do
      subject = build_email_record :email => 'franck@edu.verrot-gouv.fr'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts complete emails" do
      subject = build_email_record :email => 'Mikel Lindsaar (My email address) <mikel@test.lindsaar.net>'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "rejects email addresses without TLD" do
      subject = build_email_record :email => 'franck@verrotfr'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end

  describe "with: #<Proc>" do
    it "rejects any false result" do
      subject = build_email_record({:email => "franck@verrot.fr"}, {:with => lambda {|e| false }})
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "accepts any true result" do
      subject = build_email_record({:email => "franck@verrot.fr"}, {:with => lambda {|e| true }})
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "passes in the parsed email address" do
      subject = build_email_record({:email => "franck@hotmail.com"}, {:with => lambda {|email| not email.domain == "hotmail.com" }})
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "rejects a nil result" do
      subject = build_email_record({:email => "franck@verrot.fr"}, {:with => lambda {|email| email.domain =~ /\.com\Z/ }})
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "accepts a numerical result" do
      subject = build_email_record({:email => "franck@verrot.fr"}, {:with => lambda {|email| email.domain =~ /\.fr\Z/ }})
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end
  end

  describe "for invalid emails" do
    it "rejects invalid emails" do
      subject = build_email_record :email => 'franck.fr'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it 'rejects local emails' do
      subject = build_email_record :email => 'franck.fr'
      subject.email = 'franck'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it 'generates an error message of type invalid' do
      subject = build_email_record :email => 'franck@verrot@fr'
      subject.valid?.must_equal false

      message = subject.errors.generate_message(:email, :invalid)
      subject.errors[:email].include?(message).must_equal true
    end
  end

  before { TestRecord.reset_callbacks(:validate) }
  it "checks validity of the arguments" do
    [3, "foo", 1..6].each do |wrong_argument|
      assert_raises(ArgumentError,"Not a callable object #{wrong_argument.inspect}") do
        TestRecord.validates :email, :email => { :with => wrong_argument }
      end
    end
  end

  def build_email_record(attrs = {}, opts = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :email, :email => { :strict => opts[:strict], :with => opts[:with] }
    TestRecord.new attrs
  end
end
