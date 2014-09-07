module ActiveModel
  module Validations
    class BarcodeValidator < EachValidator
      # We check the validity of :format option
      # More at https://github.com/rails/rails/blob/aa7fdfb859d8a73f58460a7aba7174a47b5101d5/activemodel/lib/active_model/validator.rb#L180
      def check_validity!
        format = options.fetch(:format)
        raise ArgumentError, ":format cannot be blank!" if format.blank?
        method = "valid_#{format.to_s}?"
        raise ArgumentError, "Barcode format (#{format}) not supported" unless self.respond_to?(method)
      end

      def validate_each(record, attribute, value)
        method = "valid_#{options[:format].to_s}?"
        record.errors.add(attribute) if value.blank? || !self.send(method, value.to_s)
      end

      def valid_ean13?(value)
        if value =~ /^\d{13}$/
          ean13_check_digit(value.slice(0,12)) == value.slice(12)
        end
      end

      private
        # Comes from http://fr.wikipedia.org/wiki/Code-barres_EAN
        def ean13_check_digit(value)
          even_sum, uneven_sum = 0, 0
          value.split('').each_with_index do |digit, index|
            if (index+1).even?
              even_sum += digit.to_i
            else
              uneven_sum += digit.to_i
            end
          end
          (10 - ((even_sum*3 + uneven_sum) % 10)).to_s
        end
    end
  end
end
