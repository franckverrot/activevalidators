module ActiveModel
  module Validations

    class CreditCardValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) unless Luhn.valid?(options[:type], sanitize_card(value))
      end

      def sanitize_card(value)
        value.tr('- ','')
      end

      class Luhn
        def self.valid?(card_type,number)
          if card_type == :any
            self.luhn_valid?(number)
          else
            self.send("#{card_type.to_s}?", number)
          end
        end

        def self.mastercard?(number)
          self.luhn_valid?(number) and !(number !~ /^5[1-5].{14}/)
        end

        def self.visa?(number)
          self.luhn_valid?(number) and !(number !~ /^4.{15}/)
        end

        def self.amex?(number)
          self.luhn_valid?(number) and !(number !~ /^3[47].{13}/)
        end

        def self.luhn_valid?(s)
          return false unless s && s.is_a?(String)
          return false if s.empty?
          value = s.gsub(/\D/, '')
          return false if value.empty?
          value.
            reverse.
            each_char.
            collect(&:to_i).
            each_with_index.
            inject(0) {| num, (i, index) |
              num + if (index + 1) % 2 == 0
                      i*=2; ((i > 9) ? (i % 10) + 1 : i)
              else
                i
              end
          } % 10 == 0
        end

      end
    end

  end
end
