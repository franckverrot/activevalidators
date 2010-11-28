module Models
  class PhoneValidatorModel
    include ActiveModel::Validations
    attr_accessor :phone
    validates :phone, :phone => true
  end
end