require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Twitter Validation" do
  before(:each) do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :twitter_username, :twitter => true
  end
    
  subject { TestRecord.new }

  it "rejects invalid urls" do
    subject.should_not be_valid
    subject.should have(1).error
  end

  it "generates an error message of type blank" do
    subject.should_not be_valid
    subject.errors[:twitter_username].should include subject.errors.generate_message(:twitter_username, :blank)
  end
  
  describe "for twitter url validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => { :url => true }
    end

    it "validates with http" do
      subject.twitter_username = 'http://twitter.com/garrettb'
      subject.should be_valid
    end

    it "validates with https protocol" do
      subject.twitter_username = 'https://twitter.com/garrettb'
      subject.should be_valid
    end

    it "generate error with ftp protocol" do
      subject.twitter_username = 'ftp://twitter.com/garrettb'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "validates with www and http" do
      subject.twitter_username = 'http://www.twitter.com/garrettb'
      subject.should be_valid
    end

    it "generate error without www dot" do
      subject.twitter_username = 'http://wwwtwitter.com/garrettb'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error without no username" do
      subject.twitter_username = 'http://twitter.com'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error without no username and trailing slash" do
      subject.twitter_username = 'http://twitter.com/'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with too long of username" do
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoelwashere'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with invalid character" do
      subject.twitter_username = 'http://twitter.com/garrettbjerkhoé'
      subject.should_not be_valid
      subject.should have(1).error
    end
  end
  
  describe "for twitter at sign validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => { :username_with_at => true }
    end

    it "validate with valid username" do
      subject.twitter_username = '@garrettb'
      subject.should be_valid
    end

    it "validate with one character" do
      subject.twitter_username = '@a'
      subject.should be_valid
    end

    it "generate error with too long of username" do
      subject.twitter_username = '@garrettbjerkhoelwashere'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with no username" do
      subject.twitter_username = '@'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with invalid character" do
      subject.twitter_username = '@érik'
      subject.should_not be_valid
      subject.should have(1).error
    end
  end
  
  describe "for twitter without at sign validator" do
    before do
      TestRecord.reset_callbacks(:validate)
      TestRecord.validates :twitter_username, :twitter => true
    end

    it "validate with valid username" do
      subject.twitter_username = 'garrettb'
      subject.should be_valid
    end

    it "validate with one character" do
      subject.twitter_username = 'a'
      subject.should be_valid
    end

    it "generate error with too long of username" do
      subject.twitter_username = 'garrettbjerkhoelwashere'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with no username" do
      subject.twitter_username = ''
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with invalid character" do
      subject.twitter_username = 'érik'
      subject.should_not be_valid
      subject.should have(1).error
    end

    it "generate error with at sign character" do
      subject.twitter_username = '@garrettb'
      subject.should_not be_valid
      subject.should have(1).error
    end
  end
end
