class DeviceSessionSerializer < ActiveModel::Serializer
  attributes :id, :username, :imei, :status
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+
                              :device_session.to_s, Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data
  end

end
