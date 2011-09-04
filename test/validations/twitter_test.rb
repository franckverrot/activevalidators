# coding: utf-8
require 'test_helper.rb'

describe "Twitter Validation" do
  def build_twitter_record format, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :twitter_username, :twitter => format
    TestRecord.new attrs
  end

  it "rejects invalid urls" do
    subject = build_twitter_record true
    subject.valid?.must_equal false
    subject.errors.size.must_equal 1
  end

  it "generates an error message of type blank" do
    subject = build_twitter_record true
    subject.valid?.must_equal false
    subject.errors[:twitter_username].include?(subject.errors.generate_message(:twitter_username, :blank)).must_equal true
  end

  describe "for twitter url validator" do
    it "validates with http" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettb'
      subject.valid?.must_equal true
    end

    it "validates with https protocol" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'https://twitter.com/garrettb'
      subject.valid?.must_equal true
    end

    it "generate error with ftp protocol" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'ftp://twitter.com/garrettb'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "validates with www and http" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://www.twitter.com/garrettb'
      subject.valid?.must_equal true
    end

    it "generate error without www dot" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://wwwtwitter.com/garrettb'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error without no username" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error without no username and trailing slash" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with too long of username" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoelwashere'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      subject = build_twitter_record :format => :url
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoé'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end

  describe "for twitter at sign validator" do
    it "validate with valid username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@garrettb'
      subject.valid?.must_equal true
    end

    it "validate with one character" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@a'
      subject.valid?.must_equal true
    end

    it "generate error with too long of username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@garrettbjerkhoelwashere'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with no username" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      subject = build_twitter_record :format => :username_with_at
      subject.twitter_username = '@érik'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end

  describe "for twitter without at sign validator" do
    it "validate with valid username" do
      subject = build_twitter_record true
      subject.twitter_username = 'garrettb'
      subject.valid?.must_equal true
    end

    it "validate with one character" do
      subject = build_twitter_record true
      subject.twitter_username = 'a'
      subject.valid?.must_equal true
    end

    it "generate error with too long of username" do
      subject = build_twitter_record true
      subject.twitter_username = 'garrettbjerkhoelwashere'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with no username" do
      subject = build_twitter_record true
      subject.twitter_username = ''
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      subject = build_twitter_record true
      subject.twitter_username = 'érik'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generate error with at sign character" do
      subject = build_twitter_record true
      subject.twitter_username = '@garrettb'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end
  end
end
