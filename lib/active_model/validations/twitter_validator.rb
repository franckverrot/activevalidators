module ActiveModel
  module Validations

    class TwitterValidator < EachValidator
      def validate_each(record, attribute, value)
        format = options[:format].to_sym if options[:format]
        
        if value.nil?
          record.errors.add_on_blank(attribute)
        elsif format == :url
          match = value.match(/^https?:\/\/(www\.)?twitter.com\/([A-Za-z0-9_]{1,15})$/i)
          record.errors.add(attribute) unless match && !match[2].nil? # www. is first capture
        elsif format == :username_with_at
          record.errors.add(attribute) unless value.match(/^@([A-Za-z0-9_]{1,15})$/i)
        else
          record.errors.add(attribute) unless value.match(/^([A-Za-z0-9_]{1,15})$/i)
        end
      end
    end

  end
end
