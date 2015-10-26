class DeviceSerializer < ModelWithStatusSerializer
  include ActionView::Helpers::AssetUrlHelper
  attributes  :name, :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform, :os_version, :baseband_version,
              :brand, :model, :phone_number, :id_cisco_asa, :screen_size, :screen_resolution, :camera, :sd_memory_card,
              :gmail_account, :comments, :status
  self.root = false

  def attributes
    data = super
    model_png = "#{model}.png"
    model_png = 'default_device.png' if Rails.application.assets.find_asset("devices/#{model}.png").nil?
    data[:icon_url] = "assets/devices/#{model_png}"
    data
  end

end
