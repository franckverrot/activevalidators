require 'test_helper.rb'

describe "Email Validation" do
  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :email, :email => true
    @subject = TestRecord.new
  end
  

  it "accepts valid emails" do
    @subject.email = 'franck@verrot.fr'
    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  it "accepts complete emails" do
    @subject.email = 'Mikel Lindsaar (My email address) <mikel@test.lindsaar.net>'
    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  describe "for invalid emails" do
    before :each do
      @subject.email = 'franck.fr'
    end

    it "rejects invalid emails" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it 'rejects local emails' do
      @subject.email = 'franck'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:email].include?(@subject.errors.generate_message(:email, :invalid)).must_equal true
    end
  end
end
