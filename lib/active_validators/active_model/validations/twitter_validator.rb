module ActiveModel
  module Validations

    class TwitterValidator < EachValidator

      # Basic username regexp
      TWITTER_USERNAME_REGEXP = /([A-Za-z0-9_]{1,15})/i

      # Regexp used to detect twitter username within the URL.
      TWITTER_URL_REGEXP = %r{\Ahttps?://(?:www\.)?twitter.com/#{TWITTER_USERNAME_REGEXP}\z}i

      # Regexp to test using twitter username as @sign.
      TWITTER_ATSIGN_REGEXP = /\A@#{TWITTER_USERNAME_REGEXP}\z/i

      # Regexp to test against usernames without the @sign
      TWITTER_NOATSIGN_REGEXP = /\A#{TWITTER_USERNAME_REGEXP}\z/i

      def validate_each(record, attribute, value)
        format = options[:format].to_sym if options[:format]

        if value.nil?
          record.errors.add_on_blank(attribute)
        elsif format == :url
          match = value.match(TWITTER_URL_REGEXP)
          record.errors.add(attribute) unless match && !match[1].nil?
        elsif format == :username_with_at
          record.errors.add(attribute) unless value =~ TWITTER_ATSIGN_REGEXP
        else
          record.errors.add(attribute) unless value =~ TWITTER_NOATSIGN_REGEXP
        end
      end
    end

  end
end
