module ActiveModel
  module Validations
    class TupleUniquenessValidator < Validator

      def validate(record)
        @record = record
        return unless model.exists?(conditions)
        record.errors[:base] << error_message 
      end

      private

      def conditions
        fields.inject({}) do |hash, field|
          hash.merge({field => @record.send(field)})
        end
      end

      def fields
        options[:fields]
      end

      def model
        options[:model] || @record.class
      end

      def error_message
        options[:message] ||
          "["+fields.map { |field| model.human_attribute_name(field) }.join(", ")+"] " + 
          I18n.t("activerecord.errors.messages.taken")
      end
    end
  end
end
