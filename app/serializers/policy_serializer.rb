class PolicySerializer < ModelWithStatusSerializer
  attributes :type, :name, :description, :rules, :status
  has_many :rules
  self.root = false
end
