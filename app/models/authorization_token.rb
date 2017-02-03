class AuthorizationToken
  include ActiveModel::Serialization
  attr_accessor :id, :access_token, :token_type

  def initialize(access_token)
    self.id = access_token
    self.access_token = access_token
    self.token_type = 'Bearer'
  end
end