module Models
  class UrlValidatorModel
    include ActiveModel::Validations
    attr_accessor :url
    validates :url, :url => true
  end
end
