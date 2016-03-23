class RuleSerializer < ModelWithStatusSerializer
  attributes :id, :action, :name, :description, :value, :exception, :entities, :status
  has_many :entities
  self.root = false

  def attributes
    data = super
    #data[:applies_to_entities] =  data[:applies_to_entities].first.entity
    p object.entities.to_json
    hashids = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end

  def include_entities?
    !options[:include].nil? && options[:include].include?('entities')
  end
end
