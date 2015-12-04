class RoleSerializer < ModelWithStatusSerializer
  attributes :role, :description, :status
  has_many :permissions
  #has_many :users, embed: :username, include: false
  self.root = false
  def include_permissions?
    options[:include_permissions]
  end
end
