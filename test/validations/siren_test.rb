require 'test_helper'
ActiveValidators.activate(:siren)

describe "Siren Validation" do
  it "Rejects if not supplied" do
    subject = build_siren_record true
    _(subject.valid?).must_equal(false)
    _(subject.errors.size).must_equal(1)
  end

  describe 'supplied as a string' do
    it "Accepts if valid" do
      subject = build_siren_record true, :siren => '552100554'
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "Reject if invalid" do
      subject = build_siren_record true, :siren => '552100553'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "Reject if not the right size" do
      subject = build_siren_record true, :siren => '55210055'
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end

  describe 'supplied as a number' do
    it "Accepts if valid" do
      subject = build_siren_record true, :siren => 732829320
      _(subject.valid?).must_equal(true)
      _(subject.errors.size).must_equal(0)
    end

    it "Reject if invalid" do
      subject = build_siren_record true, :siren => 732829321
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end

    it "Reject if not the right size" do
      subject = build_siren_record true, :siren => 73282932
      _(subject.valid?).must_equal(false)
      _(subject.errors.size).must_equal(1)
    end
  end

  def build_siren_record siren, attrs = {}
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :siren, :siren => siren
    TestRecord.new attrs
  end
end
