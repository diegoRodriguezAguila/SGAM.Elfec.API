class UserGroupSerializer < ModelWithStatusSerializer
  attributes :id, :name, :description, :status
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt, 5)
    data[:id] = hashids.encode(data[:id])
    data
  end
end
