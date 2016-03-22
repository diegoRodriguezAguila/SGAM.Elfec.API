class RuleSerializer < ActiveModel::Serializer
  attributes :id, :action, :name, :description, :value, :exception, :status
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:rule.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end
end
