require 'active_model'
require 'phony'
require 'countries'
require 'active_validators/one_nine_shims/one_nine_string'

module ActiveValidators
  def self.activevalidators
    %w(email url respond_to phone slug ip credit_card date password twitter postal_code tracking_number siren ssn sin nino barcode date hex_color)
  end

  # Require each validator independently or just pass :all
  #
  # call-seq:
  #   ActiveValidators.activate(:phone, :email, :date)
  #   ActiveValidators.activate(:all)
  def self.activate(*validators)
    syms = validators.include?(:all) ? activevalidators : validators.map(&:to_s) & activevalidators

    syms.each do |validator_name|
      require "active_model/validations/#{validator_name}_validator"
    end
  end

  # Defines methods like validates_credit_card
  def define_helper_method_for_validator(validator)
    define_method('validates_'+validator) do |*fields|
      options ||= (fields.delete fields.find { |f| f.kind_of? Hash}) || true
      args = fields.push({ validator => options })
      validates(*args)
    end
  end
end
