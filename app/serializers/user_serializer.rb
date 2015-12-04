class UserSerializer < ModelWithStatusSerializer
  attributes :username, :authentication_token, :first_name,
             :last_name, :email, :position, :company_area,
             :roles, :status
  has_many :roles
  self.root = false
  #cache key: 'roles', expires_in: 3.hours

  def include_authentication_token?
    scope.username==object.username && options[:show_token]
  end
  def include_roles?
    options[:include_roles]
  end
end
