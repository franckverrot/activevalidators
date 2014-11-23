require 'credit_card_validations'
module ActiveModel
  module Validations

    class CreditCardValidator < EachValidator
      def validate_each(record, attribute, value)
        brand = options.fetch(:type, :any)
        brands = (brand == :any ? [] : Array.wrap(brand))
        record.errors.add(attribute) if value.blank? || !ActiveCreditCardBrand.new(value).valid?(*brands)
      end

      class ActiveCreditCardBrand

        DEPRECATED_BRANDS = [
            :en_route, # belongs to Diners Club  since 1992 obsolete
            :carte_blanche, # belongs to Diners Club ,was finally phased out by 2005
            :switch #renamed to Maestro in 2002
        ]

        BRANDS_ALIASES = {
            master_card: :mastercard,
            diners_club: :diners,
            en_route: :diners,
            carte_blanche: :diners,
            switch: :maestro
        }

        def initialize(number)
          @number = number
        end

        def valid?(*brands)
          deprecated_brands(brands).each do |brand|
            ActiveSupport::Deprecation.warn("support for #{brand} will be removed in future versions, please use #{BRANDS_ALIASES[brand]} instead")
          end
          detector.valid?(*normalize_brands(brands))
        end

        private

        def detector
          CreditCardValidations::Detector.new(@number)
        end

        def deprecated_brands(brands)
          DEPRECATED_BRANDS & brands
        end

        def normalize_brands(brands = [])
          brands.uniq.each_with_index do |brand, index|
            brands[index] = BRANDS_ALIASES[brand].present? ? BRANDS_ALIASES[brand] : brand
          end
          brands
        end

      end

    end
  end
end
