class UserSerializer < ActiveModel::Serializer
  attributes :username, :authentication_token, :created_at, :updated_at
end
