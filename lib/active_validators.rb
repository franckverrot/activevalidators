require 'active_support'
require 'active_model'
require 'active_record'
require 'active_support/all'
require 'active_model/validations'
#Eager autoload the library's validators into AR::Validations
module ActiveModel
  module Validations
    extend ActiveSupport::Autoload
    autoload :EmailValidator
    autoload :UrlValidator
    autoload :RespondToValidator
    autoload :PhoneValidator
  end
end
