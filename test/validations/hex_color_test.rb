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

    subject.must_be :valid?
    subject.errors.must_be :empty?
  end

  it "accepts 3 hex characters" do
    subject.text_color = 'abc'

    subject.must_be :valid?
    subject.errors.must_be :empty?
  end

  it "accepts 6 hex characters" do
    subject.text_color = 'abc012'

    subject.must_be :valid?
    subject.errors.must_be :empty?
  end

  it "rejects non-hex characters" do
    subject.text_color = 'efg345'

    subject.must_be :invalid?
    subject.errors[:text_color].must_include invalid_message
  end

  it "rejects too few characters" do
    subject.text_color = 'ef'

    subject.must_be :invalid?
    subject.errors[:text_color].must_include invalid_message
  end

  it "rejects too many characters" do
    subject.text_color = 'efab001'

    subject.must_be :invalid?
    subject.errors[:text_color].must_include invalid_message
  end
end
