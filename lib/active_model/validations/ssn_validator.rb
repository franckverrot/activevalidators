module ActiveModel
  module Validations
    class SsnValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) if value.blank? || !SsnValidatorGeneral.valid?(options, value)
      end
    end

    # <b>DEPRECATED:</b> Please use <tt>:ssn => true</tt> instead.
    class SsnValidatorGeneral
      def self.valid?(options, value)
        if options[:type] == :usa_ssn
          warn "[DEPRECATION] providing {:type => :usa_ssn} is deprecated and will be removed in the future. Please use `:ssn => true` instead."
        end

        SsnValidatorUSA.new(value).valid?
      end
    end

    # The Social Security number is a nine-digit number in the format "AAA-GG-SSSS". The number is divided into three parts.
    # AAA - is the first, GG - is the second and the SSSS is the third.
    # More details: http://en.wikipedia.org/wiki/Social_Security_number
    class SsnValidatorUSA
      def initialize(value)
        @value = value
        @first_group_num  = value[0..2].to_i
        @second_group_num = value[3..4].to_i
        @third_group_num  = value[5..8].to_i
      end

      def valid?
        all_groups_integers? && first_group_valid? && second_group_valid? && third_group_valid?
      end

      def all_groups_integers?
        begin
          !!Integer(@value)
        rescue ArgumentError, TypeError
          false
        end
      end

      def first_group_valid?
        @first_group_num != 0 && @first_group_num != 666 && (@first_group_num < 900 || @first_group_num > 999)
      end

      def second_group_valid?
        @second_group_num != 0
      end

      def third_group_valid?
        @third_group_num != 0
      end
    end
  end
end