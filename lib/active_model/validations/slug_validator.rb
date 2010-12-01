module ActiveModel
  module Validations
    class SlugValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value == value.parameterize
          record.errors.add(attribute)
        end
      end
    end
  end
end
