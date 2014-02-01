module ActiveModel
  module Validations

    class CreditCardValidator < EachValidator
      def validate_each(record, attribute, value)
        type = options.fetch(:type, :any)
        record.errors.add(attribute) if value.blank? || !Luhn.valid?(type, sanitize_card(value))
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

        class << self
          alias :master_card? :mastercard?
        end

        def self.visa?(number)
          self.luhn_valid?(number) and !(number !~ /^4.{15}/)
        end

        def self.amex?(number)
          self.luhn_valid?(number) and !(number !~ /^3[47].{13}/)
        end

        [:diners_club, :en_route, :discover, :jcb, :carte_blanche, :switch,
          :solo, :laser].each do |card_type|
          class_eval <<-VALIDATOR, __FILE__, __LINE__ + 1
          def self.#{card_type}?(number)
            self.luhn_valid?(number)
          end
          VALIDATOR
        end

        def self.luhn_valid?(s)
          value = s.gsub(/\D/, '')
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
