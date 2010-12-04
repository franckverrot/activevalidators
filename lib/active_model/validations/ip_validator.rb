module ActiveModel
  module Validations
    require 'resolv'
    class IpValidator < EachValidator
      def validate_each(record, attribute, value)
        r = Resolv.const_get("IP#{options[:format]}")
        raise "Unknown IP validator format #{options[:format].inspect}" if r.nil?
        record.errors.add(attribute) unless !(r::Regex !~ value)
      end

    end
  end
end
