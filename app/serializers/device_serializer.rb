class DeviceSerializer < ActiveModel::Serializer
  attributes  :name, :imei, :serial, :mac_address, :platform, :os_version,
              :brand, :model, :phone_number, :screen_size, :screen_resolution, :camera, :sd_memory_card, :status
  self.root = false
end
