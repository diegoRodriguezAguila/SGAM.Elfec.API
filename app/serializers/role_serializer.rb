class RoleSerializer < ActiveModel::Serializer
  attributes :role, :description, :status

  #has_many :users, embed: :username, include: false
  self.root = false
end
