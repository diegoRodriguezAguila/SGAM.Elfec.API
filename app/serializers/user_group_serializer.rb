class UserGroupSerializer < ModelWithStatusSerializer
  attributes :id, :name, :description, :status
  has_many :members
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt, 6)
    data[:id] = hashids.encode(data[:id])
    data
  end

  def include_members?
    !options[:include].nil? && options[:include].include?('members')
  end
end
