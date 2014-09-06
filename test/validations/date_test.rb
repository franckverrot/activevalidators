require 'test_helper'
require 'active_support/core_ext/hash/reverse_merge'
ActiveValidators.activate(:date)

# ActiveValidators relies on another gem called "date_validator" edited
# by the fine folks at Codegram.
#
# If you wanna see tests for this gem, go take a look at the repository
# [on Github](https://github.com/codegram/date_validator)
describe "Date Validation" do
  it "finds the translations" do
    TestRecord.validates :start_date, :date => {:before => :end_date }
    d = TestRecord.new(:start_date => Time.now, :end_date => Time.now - 1)

    refute d.valid?
    refute_includes d.errors.to_s, 'translation missing'
  end
end
