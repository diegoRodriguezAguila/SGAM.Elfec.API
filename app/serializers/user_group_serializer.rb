class UserGroupSerializer < ModelWithStatusSerializer
  attributes :id, :name, :description, :status
  has_many :members
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:user_group.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end

  def include_members?
    !options[:include].nil? && options[:include].include?('members')
  end
end
