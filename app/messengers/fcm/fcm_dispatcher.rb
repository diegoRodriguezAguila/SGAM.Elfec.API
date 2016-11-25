module FcmDispatcher

  # Sends the fcm message to the registration ids
  # @param [Array] registration_ids
  def self.send_rule(registration_ids, rule_name)
    options = {data: {message: "Rule created:#{rule_name}", title: 'SIDEKIQ WORKS'},
               collapse_key: "signal_type"}
    FCM_CLIENT.send(registration_ids, options)
  end

  # Sends the fcm message to the registration ids
  # @param [Array] registration_ids
  # @param [Object] data
  # @param [String] collapse_key
  def self.send(registration_ids, data, collapse_key=nil)
    options = {data: data,
               collapse_key: collapse_key}
    FCM_CLIENT.send(registration_ids, options)
  end

  # Sends the fcm message to the devices
  # @param [Array] devices
  def self.send_to_devices(devices)
    reg_ids = devices.select { |d| !d.gcm_token.nil? }.map { |d| d.gcm_token.token }
    send(reg_ids, nil)
  end


  private
  FCM_CLIENT = FCM.new(Rails.configuration.fcm_api_key)
  if Rails.configuration.use_proxy
    FCM_CLIENT = FCM.new(Rails.configuration.fcm_api_key,
                             http_proxyaddr: Rails.configuration.proxy_addr,
                             http_proxyport: Rails.configuration.proxy_port)
  end
end