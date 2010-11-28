module Models
  class RespondToValidatorModel
    include ActiveModel::Validations
    attr_accessor :responder, :global_condition, :local_condition
    validates :responder, :respond_to => { :call => true, :if => :local_condition }, :if => :global_condition
  end
end
