require 'mail'

old_w, $-w = $-w, false
require 'mail/elements/address'
$-w = old_w

module ActiveModel
  module Validations
    class EmailValidator < EachValidator
      def check_validity!
        raise ArgumentError, "Not a callable object #{options[:with].inspect}" unless options[:with] == nil || options[:with].respond_to?(:call)
      end

      def validate_each(record, attribute, value)
        valid = begin
                  mail = Mail::Address.new(value)

                  basic_check(mail) && value.include?(mail.address)
                rescue Exception => _
                  false
                end

        if options[:with]
          # technically the test suite will pass without the boolean coercion
          # but we know the code is safer with it in place
          valid &&= !!options[:with].call(mail)
        end

        record.errors.add attribute, (options.fetch(:message, :invalid)) unless valid
      end

      def basic_check(mail)
        # We must check that value contains a domain and that value is an email address
        valid = !!mail.domain

        if options[:only_address]
          # We need to dig into treetop
          # A valid domain must have dot_atom_text elements size > 1
          # user@localhost is excluded
          # treetop must respond to domain
          # We exclude valid email values like <user@localhost.com>
          # Hence we use m.__send__(tree).domain
          tree = mail.__send__(:tree)
          valid &&= (tree.domain.dot_atom_text.elements.size > 1)
        else
          valid &&= (mail.domain.split('.').length > 1)
        end
        valid
      end
    end
  end
end
