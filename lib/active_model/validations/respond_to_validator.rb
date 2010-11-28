module ActiveModel
  module Validations
    class RespondToValidator < EachValidator
      RESERVED_OPTIONS = [:if, :unless]
      def validate_each(record,attribute,value)
        responders = options.dup
        RESERVED_OPTIONS.each do |opt,should_apply| responders.delete(opt) end
        responders.each do |method,dummy|
          record.errors.add(attribute) unless value.respond_to? method
        end
      end
    end
  end
end
