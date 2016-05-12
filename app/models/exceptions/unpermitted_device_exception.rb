class Exceptions::UnpermittedDeviceException < Exceptions::SecurityTransgression
  def initialize(username)
    @username = username
  end
  def message
    I18n.t(:'api.errors.session.unpermitted_device', username: @username)
  end
end