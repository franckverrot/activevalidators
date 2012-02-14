require 'mail'
module ActiveModel
  module Validations
    class EmailValidator < EachValidator
      EMAIL_REGEXP = %r{\A[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z}
      
      def validate_each(record,attribute,value)
        begin
          address = Mail::Address.new(value)
          valid   = address.domain && 
                    value.include?(address.address) &&
                    address.domain.match(EMAIL_REGEXP)
                    
        rescue Mail::Field::ParseError
          valid = false
        end
        
        record.errors.add(attribute) unless valid
      end
    end
  end
end
