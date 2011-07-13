# coding: utf-8
require File.join(File.dirname(__FILE__), '..', 'test_helper.rb')

describe "Twitter Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :twitter_username, :twitter => true
    @subject = TestRecord.new
  end

  it "rejects invalid urls" do
    @subject.valid?.must_equal false
    @subject.errors.size.must_equal 1
  end

  it "generates an error message of type blank" do
    @subject.valid?.must_equal false
    @subject.errors[:twitter_username].include?(@subject.errors.generate_message(:twitter_username, :blank)).must_equal true
  end
  
  describe "for twitter url validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => { :format => :url }
      @subject = TestRecord.new
    end

    it "validates with http" do
      @subject.twitter_username = 'http://twitter.com/garrettb'
      @subject.valid?.must_equal true
    end

    it "validates with https protocol" do
      @subject.twitter_username = 'https://twitter.com/garrettb'
      @subject.valid?.must_equal true
    end

    it "generate error with ftp protocol" do
      @subject.twitter_username = 'ftp://twitter.com/garrettb'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "validates with www and http" do
      @subject.twitter_username = 'http://www.twitter.com/garrettb'
      @subject.valid?.must_equal true
    end

    it "generate error without www dot" do
      @subject.twitter_username = 'http://wwwtwitter.com/garrettb'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error without no username" do
      @subject.twitter_username = 'http://twitter.com'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error without no username and trailing slash" do
      @subject.twitter_username = 'http://twitter.com/'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with too long of username" do
      @subject.twitter_username = 'http://twitter.com/garrettbjerkhoelwashere'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      @subject.twitter_username = 'http://twitter.com/garrettbjerkhoé'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end
  end
  
  describe "for twitter at sign validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => { :format => :username_with_at }
      @subject = TestRecord.new
    end

    it "validate with valid username" do
      @subject.twitter_username = '@garrettb'
      @subject.valid?.must_equal true
    end

    it "validate with one character" do
      @subject.twitter_username = '@a'
      @subject.valid?.must_equal true
    end

    it "generate error with too long of username" do
      @subject.twitter_username = '@garrettbjerkhoelwashere'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with no username" do
      @subject.twitter_username = '@'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      @subject.twitter_username = '@érik'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end
  end
  
  describe "for twitter without at sign validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => true
      @subject = TestRecord.new
    end

    it "validate with valid username" do
      @subject.twitter_username = 'garrettb'
      @subject.valid?.must_equal true
    end

    it "validate with one character" do
      @subject.twitter_username = 'a'
      @subject.valid?.must_equal true
    end

    it "generate error with too long of username" do
      @subject.twitter_username = 'garrettbjerkhoelwashere'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with no username" do
      @subject.twitter_username = ''
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with invalid character" do
      @subject.twitter_username = 'érik'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end

    it "generate error with at sign character" do
      @subject.twitter_username = '@garrettb'
      @subject.valid?.must_equal false
      @subject.errors.size.must_equal 1
    end
  end
end
