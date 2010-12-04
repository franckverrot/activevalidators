module ActiveModel
  module Validations
    require 'luhnacy'
    class CreditCardValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) unless LuhnWrapper.valid?(options[:type], sanitize_card(value))
      end

      def sanitize_card(value)
        value.tr('- ','')
      end

      class LuhnWrapper
        SUPPORTED_CARDS = [:mastercard, :visa, :amex]

        def self.supports?(card_type)
          SUPPORTED_CARDS.include? card_type
        end

        def self.valid?(card_type,number)
          return false unless supports?(card_type) or card_type == :any
          if card_type != :any
            Luhnacy.send("#{card_type.to_s}?", number)
          else
            SUPPORTED_CARDS.inject(false) do |result, card_type|
              result = result or Luhnacy.send("#{card_type.to_s}?", number)
            end
          end
        end
      end
    end
  end
end
