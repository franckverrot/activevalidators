module ActiveModel
  module Validations
    class UrlValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value =~ /^https?:\/\/(?i)[a-z0-9]+([-.]{1}[a-z0-9]+)*.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/
          record.errors[attribute] << (options[:message] || "is invalid") 
        end
      end
    end
  end
end
