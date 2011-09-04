require 'test_helper.rb'

describe "Url Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => true
    @subject = TestRecord.new
  end

  it "accepts valid urls" do
    @subject.url = 'http://www.verrot.fr'
    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  it "accepts valid SSL urls" do
    @subject.url = 'https://www.verrot.fr'
    @subject.valid?.must_equal true
    @subject.errors.size.must_equal 0
  end

  describe "for invalid urls" do
    before do
      @subject = TestRecord.new
      @subject.url = 'http://^^^^.fr'
    end

    it "rejects invalid urls" do
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      @subject.valid?.must_equal false
      @subject.errors[:url].include?(@subject.errors.generate_message(:url, :invalid)).must_equal true
    end
  end
end
