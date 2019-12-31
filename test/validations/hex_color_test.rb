require 'test_helper'
ActiveValidators.activate(:hex_color)

describe "Hex-Color Validation" do
  let(:invalid_message) { subject.errors.generate_message(:text_color, :invalid) }

  subject { TestRecord.new }

  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :text_color, :hex_color => true
  end

  it "accepts blank value" do
    subject.text_color = ''

    _(subject).must_be(:valid?)
    _(subject.errors).must_be(:empty?)
  end

  it "accepts 3 hex characters" do
    subject.text_color = 'abc'

    _(subject).must_be(:valid?)
    _(subject.errors).must_be(:empty?)
  end

  it "accepts 6 hex characters" do
    subject.text_color = 'abc012'

    _(subject).must_be(:valid?)
    _(subject.errors).must_be(:empty?)
  end

  it "rejects non-hex characters" do
    subject.text_color = 'efg345'

    _(subject).must_be(:invalid?)
    _(subject.errors[:text_color]).must_include(invalid_message)
  end

  it "rejects too few characters" do
    subject.text_color = 'ef'

    _(subject).must_be(:invalid?)
    _(subject.errors[:text_color]).must_include(invalid_message)
  end

  it "rejects too many characters" do
    subject.text_color = 'efab001'

    _(subject).must_be(:invalid?)
    _(subject.errors[:text_color]).must_include(invalid_message)
  end
end
