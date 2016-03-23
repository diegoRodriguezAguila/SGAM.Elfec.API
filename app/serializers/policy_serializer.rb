class PolicySerializer < ModelWithStatusSerializer
  attributes :type, :name, :description, :rules, :status
  has_many :rules
  self.root = false

  def include_rules?
    !options[:include].nil? && options[:include].include?('rules')
  end

end
