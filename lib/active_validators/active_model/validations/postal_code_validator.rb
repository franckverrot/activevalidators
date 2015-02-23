module ActiveModel
  module Validations
    class PostalCodeValidator < EachValidator
      def validate_each(record, attribute, value)
        @value = value
        unless country = options[:country]
          if country_method = options[:country_method]
            country = record.send(country_method)
          else
            country = 'us'
          end
        end
        @formats = PostalCodeValidator.known_formats[country.to_s.downcase]
        raise "No known postal code formats for country #{country}" unless @formats
        record.errors.add(attribute) if value.blank? || !matches_any?
      end

      def self.known_formats
        @@known_formats ||= {
          'ad' => ['AD###', '###'],
          'ar' => ['####', '@####@@@'],
          'at' => ['####'],
          'au' => ['####'],
          'be' => ['####'],
          'bg' => ['####'],
          'br' => ['#####-###', '########'],
          'ca' => ['@#@ #@#', '@#@#@#'],
          'ch' => ['####'],
          'cz' => ['### ##', '#####'],
          'de' => ['#####'],
          'dk' => ['####'],
          'dr' => ['#####'],
          'sp' => ['#####'],
          'fi' => ['#####'],
          'fr' => ['#####'],
          'uk' => ['@# #@@', '@## #@@', '@@# #@@', '@@## #@@', '@#@ #@@', '@@#@ #@@'],
          'gf' => ['#####'],
          'gl' => ['####'],
          'gp' => ['#####'],
          'gt' => ['#####'],
          'hr' => ['HR-#####', 'H#####'],
          'hu' => ['####'],
          'in' => ['######'],
          'ic' => ['###'],
          'it' => ['#####'],
          'jp' => ['###-####', '#######'],
          'ky' => ['KY#-####'],
          'li' => ['####'],
          'lk' => ['#####'],
          'lt' => ['LT-#####', '#####'],
          'lu' => ['####'],
          'mc' => ['#####'],
          'md' => ['MD-####'],
          'mk' => ['####'],
          'mq' => ['#####'],
          'mx' => ['#####'],
          'my' => ['#####'],
          'nl' => ['#### @@', '####@@'],
          'no' => ['####'],
          'ph' => ['####'],
          'pk' => ['#####'],
          'pl' => ['##-###', '#####'],
          'pm' => ['#####'],
          'pt' => ['####', '####-###'],
          'ru' => ['######'],
          'se' => ['SE-#### ##', '#### ##', '######'],
          'si' => ['SI- ####', 'SI-####', '####'],
          'sk' => ['### ##', '#####'],
          'sm' => ['4789#', '#'],
          'th' => ['#####'],
          'tr' => ['#####'],
          'us' => ['#####', '#####-####'],
          'wf' => ['#####'],
          'za' => ['####']
        }
      end

      def matches_any?
        false if @formats.nil? or not @formats.respond_to?(:detect)
        @formats.detect { |format| @value.match(PostalCodeValidator.regexp_from format) }
      end

      private

      def self.regexp_from(format)
        Regexp.new '\A' + ActiveValidators::OneNineShims::OneNineString.new(Regexp.escape format).gsub(/[@#]/, '@' => '[[:alpha:]]', '#' => 'd') + '\z'
      end
    end
  end
end
