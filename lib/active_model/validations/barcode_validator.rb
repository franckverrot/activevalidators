module ActiveModel
  module Validations
    class BarcodeValidator < EachValidator
      def validate_each(record, attribute, value)
        format = options.fetch(:format, :ean13)  
        method = "valid_#{format.to_s}?"
        raise "Barcode format not supported (#{format})" unless self.respond_to?(method)
        record.errors.add(attribute) if value.blank? || !self.send(method, value)
      end


      def valid_ean13?(value)
        if value =~ /^\d{13}$/
          ean13_check_digit(value.slice(0,12)) == value.slice(12)
        end
      end

      private
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
