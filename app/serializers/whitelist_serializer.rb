class WhitelistSerializer < ModelWithStatusSerializer
  attributes :id, :title, :description, :status
  has_many :permitted_apps
  self.root = false

  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:whitelist.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end
end
