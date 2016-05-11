module GcmDispatcher

  # Sends the gcm message to the registration ids
  # @param registration_ids
  def self.send(registration_ids)
    options = {data: {message: "hi mama mia"}, collapse_key: "signal_type",
      notification: {body: 'great match!',
                     title: 'Portugal vs. Denmark',
                     icon: 'myicon'
      }}
    GCM.send(registration_ids, options)
  end

  # Sends the gcm message to the devices
  # @param [Array Device] devices
  def self.send_to_devices(devices)
    reg_ids = devices.select{|d| !d.gcm_token.nil?}.map{|d| d.gcm_token.token}
    send(reg_ids)
  end


  private
  GCM = GCM.new(Rails.configuration.gcm_api_key)
end