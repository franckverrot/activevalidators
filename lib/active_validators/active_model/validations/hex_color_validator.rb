module ActiveModel
  module Validations
    class HexColorValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value =~ /\A(\h{3}){,2}\z/
          record.errors.add(attribute)
        end
      end
    end
  end
end
