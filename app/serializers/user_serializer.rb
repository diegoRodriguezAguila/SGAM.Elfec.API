class UserSerializer < ModelWithStatusSerializer
  attributes :username, :authentication_token, :first_name,
             :last_name, :email, :position, :company_area,
             :roles, :status, :created_at, :updated_at
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
