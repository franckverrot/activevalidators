require 'active_validators'

%w(models).each do |directory|
  Dir["#{File.dirname(__FILE__)}/#{directory}/*.rb"].each {|f| require f}
end

RSpec.configure do |config|
end
