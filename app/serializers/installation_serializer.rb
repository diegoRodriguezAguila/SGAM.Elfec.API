class InstallationSerializer < ModelWithStatusSerializer
  attributes :id, :package, :version, :imei, :status
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:installation.to_s,
                          Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end
end
