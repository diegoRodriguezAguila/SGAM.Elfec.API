class PolicySerializer < ActiveModel::Serializer
  attributes :type, :name, :description, :status
  self.root = false
end
