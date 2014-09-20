require 'test_helper'
ActiveValidators.activate(:regexp)

describe "Regexp Validation" do
  let(:invalid_message) { subject.errors.generate_message(:redirect_rule, :invalid) }

  subject { TestRecord.new }

  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :redirect_rule, :regexp => true
  end

  it "accepts blank value" do
    subject.redirect_rule = ''

    subject.must_be :valid?
    subject.errors.must_be :empty?
  end

  it "rejects malformed regular expressions" do
    subject.redirect_rule = '['

    subject.must_be :invalid?
    subject.errors[:redirect_rule].must_include invalid_message
  end

  it "allow proper regular expressions" do
    subject.redirect_rule = '^/vanity-url(-2014)?'

    subject.must_be :valid?
    subject.errors.must_be :empty?
  end

end
