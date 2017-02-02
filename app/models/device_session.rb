class DeviceSession < ApplicationRecord
  enum status: {opened: 'opened',
              closed: 'closed'}
  validates_presence_of :user, :username, :device, :imei, :status
  belongs_to :user
  belongs_to :device
  before_validation :update_values

  # Checks if this session can be closed
  # by certain user, and only if its currently opened
  # @param [User] by_user
  def closable_by? (by_user)
    !by_user.nil? && by_user.username==self.username && self.opened?
  end

  private

  # Ensures that the values are from the relationship
  def update_values
    self.username = self.user.nil??nil:self.user.username
    self.imei = self.device.imei.nil??nil:self.device.imei
  end
end
