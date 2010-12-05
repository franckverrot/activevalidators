module ActiveModel
  module Validations
    class IpValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) unless regex.match(value)
      end

      def check_validity!
        raise ArgumentError, "Unknown IP validator format #{options[:format].inspect}" unless [:v4, :v6].include? options[:format]
      end

      private
        def regex
          case options[:format]
          when :v4
            ipv4_regex
          when :v6
            ipv6_regex
          end
        end

        def ipv4_regex
          # Extracted from ruby 1.9.2
          regex256 = 
            /0
            |1(?:[0-9][0-9]?)?
            |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
            |[3-9][0-9]?/x
          /\A(#{regex256})\.(#{regex256})\.(#{regex256})\.(#{regex256})\z/
        end

        def ipv6_regex
          require 'resolv'
          Resolv::IPv6::Regex
        end

    end
  end
end
