module Models
  class SlugValidatorModel
    include ActiveModel::Validations
    attr_accessor :slug
    validates :slug, :slug => true
  end
end
