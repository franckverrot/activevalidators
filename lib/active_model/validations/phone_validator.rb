module ActiveModel
  module Validations
    class PhoneValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value =~ /^\d{3}-\d{3}-\d{4}|\d{3}\.\d{3}\.\d{4}|\d{10}|\d{3}\s\d{3}\s\d{4}|\(\d{3}\)\s\d{3}-\d{4}$/i
          record.errors[attribute] << (options[:message] || "is invalid") 
        end
      end
    end
  end
end