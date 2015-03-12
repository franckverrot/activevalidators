require 'active_support/core_ext/array/wrap'
require 'uri'

module ActiveModel
  module Validations

    # Public: Uses `URI.regexp` to validate URLs, by default only allows
    # the http and https protocols.
    #
    # Examples
    #
    #    validates :url, :url => true
    #    # => only allow http, https
    #
    #    validates :url, :url => %w{http https ftp ftps}
    #    # => allow http, https, ftp and ftps
    #
    class UrlValidator < EachValidator

      # Public: Creates a new instance, overrides `:protocols` if either
      # `:with` or `:in` are defined, to allow for shortcut setters.
      #
      # Examples:
      #
      #     validates :url, :url => { :protocols => %w{http https ftp} }
      #     # => accepts http, https and ftp URLs
      #
      #     validates :url, :url => 'https'
      #     # => accepts only https URLs (shortcut form of above)
      #
      #     validates :url, :url => true
      #     # => by default allows only http and https
      #
      # Raises an ArgumentError if the array with the allowed protocols
      # is empty.
      #
      # Returns a new instance.
      def initialize(options)
        options[:protocols] ||= options.delete(:protocol) || options.delete(:with) || options.delete(:in)
        super
      end

      # Internal: Ensures that at least one protocol is defined. If the protocols
      # are empty it throws an ArgumentError.
      #
      # Raises ArgumentError if protocols is empty.
      #
      # Returns nothing.
      def check_validity!
        raise ArgumentError, "At least one URI protocol is required" if protocols.empty?
      end

      # Internal: Returns an array of protocols to use with the URI regexp.
      # The default protocols are `http` and `https`.
      #
      # Returns the Array with the allowed protocols.
      def protocols
        Array.wrap(options[:protocols] || %w{http https})
      end

      # Internal: Constructs the regular expression to check
      # the URI for the configured protocols.
      #
      # Returns the Regexp.
      def uri_regexp
        @uri_regexp ||= /\A#{URI::Parser.new.make_regexp(protocols)}\z/
      end

      # Internal: Tries to convert supplied string into URI,
      # if not possible returns nil => invalid URI.
      #
      # Returns the URI or nil.
      def as_uri(value)
        URI.parse(value.to_s) rescue nil if value.present?
      end

      # Public: Validate URL, if it fails adds an error.
      #
      # Returns nothing.
      def validate_each(record, attribute, value)
        uri = as_uri(value)
        record.errors.add(attribute) unless uri && value.to_s =~ uri_regexp
      end
    end
  end
end
