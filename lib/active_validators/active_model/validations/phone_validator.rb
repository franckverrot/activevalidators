require 'phony'
require 'countries'
module ActiveModel
  module Validations
    class PhoneValidator < EachValidator
      def validate_each(record, attribute, value)
        plausible = case (country = options[:country])
                    when ->(s) { s.blank? }
                      # Without a country, try to figure out if it sounds like
                      # a plausible phone number.
                      Phony.plausible?(value)
                    else
                      # In the presence of the country option, provide Phony the country
                      # code associated with it.
                      country_code = ISO3166::Country.new(country.to_s.upcase).country_code
                      Phony.plausible?(value, :cc => country_code)
                    end

        if !plausible
          record.errors.add(attribute, :invalid)
        end
      end
    end
  end
end
