require 'test_helper.rb'

describe "Respond To Validation" do
  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :responder, :respond_to => { :call => true, :if => :local_condition }, :if => :global_condition
    @subject = TestRecord.new
  end

  it "respond_to?" do
    @subject.responder = lambda {}
    @subject.global_condition = true
    @subject.local_condition = true

    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  describe "when does not respond_to?" do
    before do
      @subject = TestRecord.new
      @subject.responder        = 42
      @subject.global_condition = true
      @subject.local_condition  = true
    end

    it "rejects the responder" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:responder].include?(@subject.errors.generate_message(:responder, :invalid)).must_equal true
    end
  end
end
