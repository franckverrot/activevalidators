require 'active_model'
require 'phony'
require 'countries'
require 'active_validators/one_nine_shims/one_nine_string'

module ActiveModel
  module Validations
    def self.activevalidators
      %w(email url respond_to phone slug ip credit_card date password twitter postal_code tracking_number siren ssn sin nino)
    end

    activevalidators.each do |validator_name|
      require "active_model/validations/#{validator_name}_validator"
    end

    require 'date_validator'

    #Defines methods like validates_credit_card
    module HelperMethods
      ActiveModel::Validations.activevalidators.each do |validator|
        define_method('validates_'+validator) do |*fields|
          options ||= (fields.delete fields.find { |f| f.kind_of? Hash}) || true
          args = fields.push({ validator => options })
          validates(*args)
        end
      end
    end
  end
end
