require 'test_helper'

describe "Slug Validation" do
  def build_slug_validation attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :slug, :slug => true
    TestRecord.new attrs
  end

  it "accepts valid slugs" do
    subject = build_slug_validation
    subject.slug = '1234567890-foo-bar-bar'
    subject.valid?.must_equal true
    subject.errors.size.must_equal 0
  end

  describe "for invalid slugs" do
    it "rejects invalid slugs" do
      subject = build_slug_validation :slug => '@#$%^'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      subject = build_slug_validation :slug => '@#$%^'
      subject.valid?.must_equal false
      subject.errors[:slug].include?(subject.errors.generate_message(:slug, :invalid)).must_equal true
    end
  end

  describe "for empty slugs" do
    it "generates an error message of type blank" do
      subject = build_slug_validation :slug => nil
      subject.valid?.must_equal false
      subject.errors[:slug].include?(subject.errors.generate_message(:slug, :blank)).must_equal true
    end
  end

end
