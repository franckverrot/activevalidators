module ActiveModel
  module Validations
    class PostalCodeValidator < EachValidator
      def validate_each(record, attribute, value)
        @value = value
        country = options[:country] || :us
        @formats = PostalCodeValidator.known_formats[country]
        raise "No known postal code formats for country #{country}" unless @formats
        record.errors.add(attribute) unless matches_any?
      end

      def self.known_formats
        @@known_formats ||= {
          :us => ['#####', '#####-####'],
        }
      end

      def matches_any?
        false if @formats.nil? or not @formats.respond_to?(:detect)
        @formats.detect { |format| @value.match(PostalCodeValidator.regexp_from format) }
      end

      private

      def self.regexp_from(format)
        Regexp.new "^"+(Regexp.escape format).gsub('\#','\d')+"$"
      end
    end
  end
end
