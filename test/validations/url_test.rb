require 'test_helper'
ActiveValidators.activate(:url)

describe "Url Validation" do
  def build_url_record
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => true
    TestRecord.new
  end

  def build_url_record_require_tld
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => { :require_tld => true }
    TestRecord.new
  end

  def build_ftp_record
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => 'ftp'
    TestRecord.new
  end

  describe "valid urls" do
    it "accepts urls without port number" do
      subject = build_url_record
      subject.url = 'http://www.verrot.fr'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "accepts urls with port number" do
      subject = build_url_record
      subject.url = 'http://www.verrot.fr:1234'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "accepts urls with basic auth" do
      subject = build_url_record
      subject.url = 'http://foo:bar@www.verrot.fr'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "accepts valid SSL urls" do
      subject = build_url_record
      subject.url = 'https://www.verrot.fr'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "accepts ftp if defined" do
      subject = build_ftp_record
      subject.url = 'ftp://ftp.verrot.fr'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "accepts urls with tld when tld validation is required" do
      subject = build_url_record_require_tld
      subject.url = 'http://verrot.fr'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end
  end

  describe "for invalid urls" do
    it "rejects invalid urls" do
      subject = build_url_record
      subject.url = 'http://^^^^.fr'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "rejects injected urls" do
      subject = build_url_record
      subject.url = "javascript:alert('xss');\nhttp://google.com"
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generates an error message of type invalid" do
      subject = build_url_record
      subject.url = 'http://^^^^.fr'
      _(subject.valid?).must_equal(false)
      _(subject.errors[:url].include?(subject.errors.generate_message(:url, :invalid))).must_equal(true)
    end

    it "rejects nil urls" do
      subject = build_url_record
      subject.url = nil
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "rejects empty urls" do
      subject = build_url_record
      subject.url = ''
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "rejects invalid protocols" do
      subject = build_url_record
      subject.url = 'ftp://ftp.verrot.fr'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "rejects urls that have no tld but required tld validation" do
      subject = build_url_record_require_tld
      subject.url = 'http://verrot'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "will not accept domains that end with a dot as a tld" do
      subject = build_url_record_require_tld
      subject.url = 'http://verrot.'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "will not accept domains that start with a dot as a tld" do
      subject = build_url_record_require_tld
      subject.url = 'http://.verrot'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end
end
