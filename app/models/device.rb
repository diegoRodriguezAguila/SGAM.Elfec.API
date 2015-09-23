class Device < ActiveRecord::Base
  validates_presence_of :imei, :serial, :mac_address, :platform, :os_version, :brand, :model, :status
  validates_uniqueness_of :name, :imei, :mac_address
  validates_numericality_of :imei, :phone_number
end
