module ActiveModel
  module Validations
    class PasswordValidator < EachValidator
      REGEXES = {
        :weak   => /(?=.{6,}).*/, # 6 characters
        :medium => /^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$/, #len=7 chars and numbers
        :strong => /^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[\d\W]).*$/#len=8 chars and numbers and special chars
      }

      def validate_each(record, attribute, value)
        required_strength = options.fetch(:strength, :weak)
        if (REGEXES[required_strength] !~ value)
          record.errors.add(attribute)
        end
      end
    end
  end
end
