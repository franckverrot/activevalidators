module ActiveModel
  module Validations
    class PhoneValidator < EachValidator
      def validate_each(record, attribute, value)
        @value = value
        @formats = PhoneValidator.known_formats[options[:country]] || PhoneValidator.known_formats[:us]
        unless matches_any?
          record.errors.add(attribute)
        end
      end

      def self.known_formats
        @@known_formats ||=
        {:us     => ["###-###-####", "##########", "###.###.####", "### ### ####", "(###) ###-####"],
         :brazil => ["## ####-####", "(##) ####-####", "##########"],
         :france => ["## ## ## ## ##"],
         :uk     => ["#### ### ####"]}
      end

      def matches_any?
        false if @formats.nil? or not @formats.respond_to?(:detect)
        @formats.detect { |format| @value.match(PhoneValidator.regexp_from format) }
      end

      private

      def self.regexp_from(format)
        Regexp.new "^"+(Regexp.escape format).gsub('\#','\d')+"$"
      end

    end
  end
end
