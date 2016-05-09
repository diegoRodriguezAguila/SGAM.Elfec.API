class DeviceGcmToken < ActiveRecord::Base
  validates :token, presence: true, uniqueness: true, allow_blank: false
  validates :device, presence: true, uniqueness: true
  belongs_to :device
end
