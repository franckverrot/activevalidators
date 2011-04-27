require 'active_support'
require 'active_model'
require 'active_record'
require 'active_support/all'
require 'active_model/validations'

module ActiveModel
  module Validations
    extend ActiveSupport::Autoload

    def self.activevalidators
      ['Email','Url','RespondTo','Phone','Slug','Ip','CreditCard','Date','Password','Twitter','PostalCode']
    end

    #Eager autoload the library's validators into AR::Validations
    activevalidators.each do |validator_name|
      autoload validator_name+'Validator'
    end

    #Defines methods like validates_credit_card
    module HelperMethods
      ActiveModel::Validations.activevalidators.map(&:underscore).each do |validator|
        define_method('validates_'+validator) do |*fields|
          options ||= (fields.delete fields.find { |f| f.kind_of? Hash}) || true
          validates *fields, validator => options
        end
      end
    end
  end
end
