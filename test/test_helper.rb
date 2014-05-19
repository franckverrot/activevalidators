gem 'minitest'
require 'minitest/autorun'
require 'minitest/mock'

# silence warnings
old_w, $-w = $-w, false

require 'activevalidators'

# unsilence warnings
$-w = old_w

class TestRecord
  include ActiveModel::Validations
  attr_accessor :ip, :url, :slug, :responder, :global_condition,
    :local_condition, :phone, :email, :card, :password, :twitter_username,
    :postal_code, :carrier, :tracking_number, :start_date, :end_date, :siren, :ssn, :sin

  def initialize(attrs = {})
    attrs.each_pair { |k,v| send("#{k}=", v) }
  end
end
