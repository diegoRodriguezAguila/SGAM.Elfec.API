class RuleSerializer < ModelWithStatusSerializer
  attributes :id, :policy_id, :action, :name, :description, :value, :exception, :entities, :status
  has_many :entities
  self.root = false

  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data[:policy_id] = object.policy.type if(!data[:policy_id].nil?)
    data
  end

  def include_entities?
    !options[:include].nil? && options[:include].include?('entities')
  end

  def include_policy_id?
    !options[:include].nil? && options[:include].include?('policy_id')
  end
end
