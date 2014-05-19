require 'active_model/validations/shared/luhn_checker'

module ActiveModel
  module Validations
    class SinValidator < EachValidator
      def validate_each(record, attribute, value)
        country = options.fetch(:country, :canada)                                                  # :canada is default.
        record.errors.add(attribute) if value.blank? || !SinValidatorGeneral.valid?(country, value, options)
      end
    end

    class SinValidatorGeneral
      def self.valid?(country, value, options)
        if country == :canada
          SinValidatorCanada.new(value, options).valid?
        end
      end
    end

    # The Social Insurance Number is a nine-digit number in the format "AAA BBB CCC".
    # The number is divided into three parts.
    # AAA - is the first, BBB - is the second and the CCC is the third.
    # Numbers that begin with the number "9" are issued to temporary residents who are not Canadian citizens
    # More details: http://en.wikipedia.org/wiki/Social_Insurance_Number
    #
    # Possible flags:
    #   allow_permanent_residents - citizens with cars, which begins with "9" are valid. By default it is false.
    #
    #   validates :sin, :sin => {:country => :canada, :country_options => {:allow_permanent_residents => true}}
    class SinValidatorCanada
      def initialize(str_value, options)
        @sin = str_value.gsub(/\D/, '') # keep only integers
        @allow_permanent_residents = false

        country_options = options.fetch(:country_options, {})
        allow_permanent_residents = country_options.fetch(:allow_permanent_residents, :nil)

        if allow_permanent_residents == true
          @allow_permanent_residents = true
        end
      end

      def valid?
        size_is?(9) && allow_permanent_residents? && LuhnChecker.valid?(@sin)
      end

      def size_is?(count)
        @sin.size == count
      end

      def allow_permanent_residents?
        permanent_residents_indentifier = "9"

        if @allow_permanent_residents == false && @sin.start_with?(permanent_residents_indentifier)
          false
        else
          true
        end
      end
    end
  end
end