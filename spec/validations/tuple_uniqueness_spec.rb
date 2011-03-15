require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Tuple uniqueness validation" do

  before do
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates_with ActiveModel::Validations::TupleUniquenessValidator, :fields => [:email, :phone]
  end

  let(:parameters) {{:email => "email", :phone => "phone"}}
  subject { TestRecord.new }

  before do
    parameters.each { |param, value| subject.send("#{param}=", value) }
  end

  it "is valid when no duplicate exists" do
    TestRecord.stub(:exists?).with(parameters).and_return(false)
    subject.should be_valid
  end

  context "when a duplicate exists" do
    before { TestRecord.stub(:exists?).with(parameters).and_return(true) }

    it "is invalid" do
      subject.should_not be_valid
    end

    it "sets an error message" do
      subject.errors[:base].should_not be_nil
    end
  end
end
