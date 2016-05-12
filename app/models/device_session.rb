class DeviceSession < ActiveRecord::Base
  enum status: {opened: 'opened',
              closed: 'closed'}
  validates_presence_of :user, :username, :device, :imei, :status
  belongs_to :user
  belongs_to :device
end
