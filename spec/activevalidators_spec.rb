require 'spec_helper'

describe "A class with active validators included" do
  subject { TestRecord }

  validators = ['Email','Url','RespondTo','Phone','Slug','Ip','CreditCard','Date','Password','Twitter'].map(&:underscore)
  validators.each do |validator|
    describe ".validates_#{validator}" do
      it "is defined" do
        subject.should respond_to("validates_#{validator}")
      end

      context "when it doesn't receive a hash with options" do
        it "calls validates #{validator} => true" do
          subject.should_receive('validates').with hash_including(validator => true)
          subject.send("validates_#{validator}")
        end

        it "calls 'validates *attributes, #{validator} => true' when fed with attributes" do
          subject.should_receive('validates').with(:attr1, :attr2, validator => true)
          subject.send("validates_#{validator}", :attr1, :attr2)
        end
      end

      context "when it receives a hash with options" do
        it "calls validates #{validator} => options" do
          subject.should_receive('validates').with hash_including(validator => {:options => :blah})
          subject.send("validates_#{validator}", :options => :blah)
        end

        it "calls 'validates *attributes, #{validator} => options' when fed with attributes" do
          subject.should_receive('validates').with(:attr1, :attr2, validator => {:options => :blah})
          subject.send("validates_#{validator}", :attr1, :attr2, :options => :blah)
        end
      end

    end
  end
end
