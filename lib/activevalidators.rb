require 'active_support'
require 'active_model'
require 'active_record'
require 'active_support/all'
require 'active_model/validations'
#Eager autoload the library's validators into AR::Validations
module ActiveModel
  module Validations
    extend ActiveSupport::Autoload

    validators = ['Email','Url','RespondTo','Phone','Slug','Ip','CreditCard','Date','Password','Twitter']
    validators.each do |validator_name|
      autoload (validator_name+'Validator').to_sym
    end
  end
end
