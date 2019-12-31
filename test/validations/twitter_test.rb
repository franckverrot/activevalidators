# coding: utf-8
require 'test_helper'
ActiveValidators.activate(:twitter)

describe "Twitter Validation" do
  def build_twitter_record format, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :twitter_username, :twitter => format
    TestRecord.new attrs
  end

  it "rejects invalid urls" do
    subject = build_twitter_record true
    _(subject.valid?).must_equal(false)
    _(subject.errors.size).must_equal(1)
  end

  it "generates an error message of type blank" do
    subject = build_twitter_record true
    _(subject.valid?).must_equal(false)

    message = subject.errors.generate_message(:twitter_username, :blank)
    _(subject.errors[:twitter_username].include?(message)).must_equal(true)
  end

  describe "for twitter url validator" do
    it "validates with http" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettb'
      _(subject.valid?).must_equal(true)
    end

    it "validates with https protocol" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'https://twitter.com/garrettb'
      _(subject.valid?).must_equal(true)
    end

    it "generate error with ftp protocol" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'ftp://twitter.com/garrettb'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "validates with www and http" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://www.twitter.com/garrettb'
      _(subject.valid?).must_equal(true)
    end

    it "generate error without www dot" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://wwwtwitter.com/garrettb'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error without no username" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error without no username and trailing slash" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with too long of username" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoelwashere'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with invalid character" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoé'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generates error with injected content" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = "javascript:alert('xss');\nhttp://twitter.com/garrettbjerkhoelwashere"
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end

  describe "for twitter at sign validator" do
    it "validate with valid username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@garrettb'
      _(subject.valid?).must_equal(true)
    end

    it "validate with one character" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@a'
      _(subject.valid?).must_equal(true)
    end

    it "generate error with too long of username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@garrettbjerkhoelwashere'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with no username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with invalid character" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@érik'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with injected content" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = "injected\n@erik"
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end

  describe "for twitter without at sign validator" do
    it "validate with valid username" do
      subject = build_twitter_record true
      subject.twitter_username = 'garrettb'
      _(subject.valid?).must_equal(true)
    end

    it "validate with one character" do
      subject = build_twitter_record true
      subject.twitter_username = 'a'
      _(subject.valid?).must_equal(true)
    end

    it "generate error with too long of username" do
      subject = build_twitter_record true
      subject.twitter_username = 'garrettbjerkhoelwashere'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with no username" do
      subject = build_twitter_record true
      subject.twitter_username = ''
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with invalid character" do
      subject = build_twitter_record true
      subject.twitter_username = 'érik'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with at sign character" do
      subject = build_twitter_record true
      subject.twitter_username = '@garrettb'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "generate error with at injected data" do
      subject = build_twitter_record true
      subject.twitter_username = "something\ngarrettb\nelse"
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end
end
