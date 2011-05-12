module ActiveModel
  module Validations
    class TrackingNumberValidator < EachValidator
      def validate_each(record, attribute, value)
        @value = value
        carrier = options[:carrier]
        raise "Carrier option required" unless carrier
        @formats = TrackingNumberValidator.known_formats[carrier]
        raise "No known tracking number formats for carrier #{carrier}" unless @formats
        record.errors.add(attribute) unless matches_any?
      end

      def self.known_formats
        @@known_formats ||= {
          # see https://www.ups.com/content/us/en/tracking/help/tracking/tnh.html
          :ups => ['1Z9999999999999999', '999999999999', 'T9999999999', '999999999'],
        }
      end

      def matches_any?
        false if @formats.nil? or not @formats.respond_to?(:detect)
        @formats.detect { |format| @value.match(TrackingNumberValidator.regexp_from format) }
      end

      private

      def self.regexp_from(format)
        Regexp.new "^"+(Regexp.escape format).gsub('\#','\d')+"$"
      end
    end
  end
end
