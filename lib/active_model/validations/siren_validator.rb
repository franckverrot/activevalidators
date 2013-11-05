module ActiveModel
  module Validations
    class SirenValidator < EachValidator
      # Validates siren format according to
      # http://fr.wikipedia.org/wiki/SIREN
      def valid_siren?(input)
        str = input.to_s
        reversed_array = str.split('').reverse

        digits = reversed_array.each_with_index.map do |char, i|
          coeff = (i % 2) + 1
          (char.to_i * coeff).to_s.split('')
        end

        sum = digits.flatten.map(&:to_i).inject(:+)

        (sum % 10) == 0
      end

      def validate_each(record, attribute, value)
        if value.nil?
          record.errors.add_on_blank(attribute)
        else
          if value.to_s.length != 9
            record.errors.add attribute, :length
          else
            record.errors.add attribute, :format unless valid_siren?(value)
          end
        end
      end
    end
  end
end
