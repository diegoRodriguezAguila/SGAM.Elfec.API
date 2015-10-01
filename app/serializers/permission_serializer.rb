class PermissionSerializer < ModelWithStatusSerializer
  attributes :name, :description, :status
end
