class RoleSerializer < ActiveModel::Serializer
  attributes :role, :description, :status

  belongs_to :user_id
end
