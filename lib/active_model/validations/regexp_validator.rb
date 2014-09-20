module ActiveModel
  module Validations
    class RegexpValidator < EachValidator
      def validate_each(record, attribute, value)
        unless valid_regexp?(value)
          record.errors.add(attribute)
        end
      end


      private

      def valid_regexp?(value)
        Regexp.compile(value.to_s)
        true

      rescue RegexpError
        false
      end
    end
  end
end
