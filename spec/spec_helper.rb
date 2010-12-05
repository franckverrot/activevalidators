require 'activevalidators'

%w(models).each do |directory|
  Dir["#{File.dirname(__FILE__)}/#{directory}/*.rb"].each {|f| require f}
end

RSpec.configure do |config|
end

class TestRecord
  include ActiveModel::Validations
  attr_accessor :ipv4, :ipv6, :url, :slug, :responder, :global_condition, :local_condition, :phone, :email, :card
end
