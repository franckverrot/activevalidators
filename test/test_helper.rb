gem 'minitest'
require 'minitest/autorun'
require 'minitest/mock'
old_w, $-w = $-w, false
require 'active_support/test_case'
$-w = old_w
require 'activevalidators'

class TestRecord
  include ActiveModel::Validations
  attr_accessor :ip, :url, :slug, :responder, :global_condition,
    :local_condition, :phone, :email, :card, :password, :twitter_username,
    :postal_code, :carrier, :tracking_number, :start_date, :end_date, :siren, :ssn, :sin, :nino, :barcode,
    :text_color, :redirect_rule

  def initialize(attrs = {})
    attrs.each_pair { |k,v| send("#{k}=", v) }
  end
end

class Minitest::Spec
  include ActiveSupport::Testing::Deprecation
end
