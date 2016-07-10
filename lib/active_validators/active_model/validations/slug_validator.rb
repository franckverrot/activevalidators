module ActiveModel
  module Validations
    class SlugValidator < EachValidator
      def validate_each(record, attribute, value)
        if value.nil?
          record.errors.add(attribute, :blank)
        elsif value != value.parameterize
          record.errors.add(attribute)
        end
      end
    end
  end
end
