require 'test_helper.rb'

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
    
    it "accepts complete emails" do
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
    
    it "accepts complete emails" do
      subject = build_email_record :email => 'franck@verrotfr'
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
      subject = build_email_record :email => 'franck.fr'
      subject.valid?.must_equal false
      subject.errors[:email].include?(subject.errors.generate_message(:email, :invalid)).must_equal true
    end
  end

  def build_email_record(attrs = {}, opts = {})
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :email, :email => { :strict => opts[:strict] }
    TestRecord.new attrs
  end
end
