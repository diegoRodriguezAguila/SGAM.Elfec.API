module GcmDispatcher

  # Sends the gcm message to the registration ids
  # @param [Array] registration_ids
  def self.send(registration_ids, rule_name)
    options = {data: {message: "Rule created:#{rule_name}",title:'SIDEKIQ WORKS'},
               collapse_key: "signal_type" }
    GCM.send(registration_ids, options)
  end

  # Sends the gcm message to the devices
  # @param [Array] devices
  def self.send_to_devices(devices)
    reg_ids = devices.select{|d| !d.gcm_token.nil?}.map{|d| d.gcm_token.token}
    send(reg_ids, nil)
  end


  private
  GCM = GCM.new(Rails.configuration.gcm_api_key)
end