module ActiveModel
  module Validations
    class SlugValidator < EachValidator
      def validate_each(record, attribute, value)
        if value.nil?
          record.errors.add_on_blank(attribute)
        elsif value != value.parameterize
          record.errors.add(attribute)
        end
      end
    end
  end
end
