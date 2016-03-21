class PolicySerializer < ActiveModel::Serializer
  attributes :type, :name, :description, :rules, :status
  has_many :rules
  self.root = false
end
