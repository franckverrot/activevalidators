module ActiveModel
  module Validations
    class NinoValidator < EachValidator
      def validate_each(record, attribute, value)
        record.errors.add(attribute) if value.blank? || !NinoValidatorUK.new(value).valid?
      end
    end

    # The National Insurance number is a number used in the United Kingdom.
    # The format of the number is two prefix letters, six digits, and one suffix letter. The example used is typically AB123456C.
    # Where AB - prefix, 123456 - number, C - suffix.
    # More details: http://en.wikipedia.org/wiki/National_Insurance_number
    class NinoValidatorUK
      def initialize(value)
        @nino        = value.gsub(/\s/, '').upcase                                                  # Remove spaces (they may be) and make text to be same.
        @first_char  = @nino[0]
        @second_char = @nino[1]
        @prefix      = @nino[0..1]
        @number      = @nino[2..7]
        @suffix      = @nino[-1]
      end

      def valid?
        size_is?(9) && first_char_valid? && second_char_valid? && prefix_valid? &&
        prefix_not_allocated? && prefix_not_administrative_number? && number_valid? && suffix_valid?
      end

      private

      def size_is?(count)
        @nino.size == count
      end

      def first_char_valid?
        forbidden_chars = %w[D F I Q U V]
        !forbidden_chars.include?(@first_char)
      end

      def second_char_valid?
        forbidden_chars = %w[D F I Q U V O]
        !forbidden_chars.include?(@second_char)
      end

      def prefix_valid?
        prefix_rule = /[a-zA-Z]{2}/                                                                 # Exactly 2 alphabet chars.
        !!(prefix_rule =~ @prefix)
      end

      def number_valid?
        number_rule = /^[0-9]{6}$/                                                                  # Exactly 6 digits.
        !!(number_rule =~ @number)
      end

      def suffix_valid?
        allowed_chars = %w[A B C D]
        allowed_chars.include?(@suffix)
      end

      def prefix_not_allocated?
        forbidden_prefixes = %w[BG GB NK KN TN NT ZZ]
        !forbidden_prefixes.include?(@prefix)
      end

      def prefix_not_administrative_number?
        administrative_prefixes = %w[OO CR FY MW NC PP PY PZ]
        !administrative_prefixes.include?(@prefix)
      end
    end
  end
end
