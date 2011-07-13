require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Slug Validation" do
  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :slug, :slug => true
    @subject = TestRecord.new
  end

  it "accepts valid slugs" do
    @subject.slug = '1234567890-foo-bar-bar'
    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  describe "for invalid slugs" do
    before do
    @subject = TestRecord.new
      @subject.slug = '@#$%^'
    end

    it "rejects invalid slugs" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:slug].include?(@subject.errors.generate_message(:slug, :invalid)).must_equal true
    end
  end

  describe "for empty slugs" do
    before do
      @subject = TestRecord.new
      @subject.slug = nil
    end

    it "generates an error message of type blank" do
      @subject.valid?.must_equal false
      @subject.errors[:slug].include?(@subject.errors.generate_message(:slug, :blank)).must_equal true
    end
  end

end
