module Models
  class IpValidatorModel
    include ActiveModel::Validations
    attr_accessor :ipv4, :ipv6
    validates :ipv4, :ip => { :format => :v4 }, :if => :ipv4
    validates :ipv6, :ip => { :format => :v6 }, :if => :ipv6
  end
end
