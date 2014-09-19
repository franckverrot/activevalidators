module ActiveModel
  module Validations
    class RegexpValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) if !RegexpValidatorCore.new(value).valid?
      end
    end

    class RegexpValidatorCore
      def initialize(value)
        @value = value
      end

      def valid?
        begin
          Regexp.compile(@value)
          true
        rescue Exception
          false
        end
      end
    end
  end
end