module Models
  class CreditCardValidatorModel
    include ActiveModel::Validations
    attr_accessor :card
    validates :card,  :credit_card => { :type => :any }, :if => :card
  end
end
