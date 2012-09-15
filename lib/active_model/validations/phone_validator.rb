module ActiveModel
  module Validations
    class PhoneValidator < EachValidator
      def validate_each(record, attribute, value)
        country_code = Country.new(options[:country].to_s.upcase).country_code unless options[:country].blank?
        record.errors.add(attribute, options[:message]) if value.blank? || ! (options[:country].blank? ? Phony.plausible?(value) : Phony.plausible?(value, :cc => country_code) )
      end

    end
  end
end
