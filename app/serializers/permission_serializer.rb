class PermissionSerializer < ActiveModel::Serializer
  attributes :name, :description, :status
end
