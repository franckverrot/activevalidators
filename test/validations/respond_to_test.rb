require 'test_helper'
ActiveValidators.activate(:respond_to)

describe "Respond To Validation" do
  def build_respond_to_record attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :responder, :respond_to => { :call => true, :if => :local_condition }, :if => :global_condition
    TestRecord.new attrs
  end

  it "respond_to?" do
    subject = build_respond_to_record
    subject.responder = lambda {}
    subject.global_condition = true
    subject.local_condition = true

    _(subject.valid?).must_equal(true)
    _(subject.errors.size).must_equal(0)
  end

  describe "when does not respond_to?" do
    it "rejects the responder" do
      subject = build_respond_to_record :responder => 42, :global_condition => true, :local_condition => true
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generates an error message of type invalid" do
      subject = build_respond_to_record :responder => 42, :global_condition => true, :local_condition => true
      _(subject.valid?).must_equal(false)
      _(subject.errors[:responder].include?(subject.errors.generate_message(:responder, :invalid))).must_equal(true)
    end
  end
end
