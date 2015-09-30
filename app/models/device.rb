class Device < ActiveRecord::Base
  enum status: [:unauthorized, :authorized, :auth_pending]
  validates_presence_of :imei, :serial, :wifi_mac_address, :bluetooth_mac_address, :platform,
                        :os_version, :baseband_version, :brand, :model, :gmail_account, :status
  validates_uniqueness_of :name, :imei, :wifi_mac_address, :bluetooth_mac_address
  validates_numericality_of :imei, :phone_number, allow_nil: true
  validates_inclusion_of :platform, in: ['Android']
  validates :wifi_mac_address, :bluetooth_mac_address, mac_address: true, allow_nil: true
  validates :imei, imei: true, allow_nil: true
end
