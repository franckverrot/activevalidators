module Models
  class EmailValidatorModel
    include ActiveModel::Validations
    attr_accessor :email
    validates :email, :email => true
  end
end
