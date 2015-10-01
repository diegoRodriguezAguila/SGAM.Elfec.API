class DeviceSerializer < ModelWithStatusSerializer
  attributes  :name, :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform, :os_version, :baseband_version,
              :brand, :model, :phone_number, :id_cisco_asa, :screen_size, :screen_resolution, :camera, :sd_memory_card,
              :gmail_account, :comments, :status
  self.root = false

end
