require 'mail'
module ActiveModel
  module Validations
    class EmailValidator < EachValidator
      def validate_each(record,attribute,value)
        begin
          address = Mail::Address.new(value)
          valid = address.domain && value.include?(address.address)
        rescue Mail::Field::ParseError
          valid = false
        end
        record.errors.add(attribute) unless valid
      end
    end
  end
end
