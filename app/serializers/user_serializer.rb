class UserSerializer < ActiveModel::Serializer
  attributes :username, :authentication_token, :roles, :created_at, :updated_at
  has_many :roles
  self.root = false
  #cache key: 'roles', expires_in: 3.hours
  def attributes
    data = super
    if options[:hide_token]
      return data.except!(:authentication_token)
    end
    data
  end
end
