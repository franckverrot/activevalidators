require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Slug Validation" do
  it "accepts valid slugs" do
    model = Models::SlugValidatorModel.new
    model.slug = '1234567890-foo-bar-bar'
    model.valid?.should be(true)
    model.should have(0).errors
  end

  describe "for invalid slugs" do
    let(:model) do
      Models::SlugValidatorModel.new.tap do |m|
        m.slug = '@#$%^'
      end
    end

    it "rejects invalid slugs" do
      model.valid?.should be(false)
      model.should have(1).errors
    end

    it "generates an error message of type invalid" do
      model.valid?.should be(false)
      model.errors[:slug].should == [model.errors.generate_message(:slug, :invalid)]
    end
  end
end
