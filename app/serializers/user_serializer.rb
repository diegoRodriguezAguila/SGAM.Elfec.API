class UserSerializer < ActiveModel::Serializer
  attributes :username, :authentication_token, :roles, :created_at, :updated_at
  has_many :roles
  self.root = false
  #cache key: 'roles', expires_in: 3.hours
end
