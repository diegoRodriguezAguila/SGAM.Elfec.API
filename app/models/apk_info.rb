# apk info object class
class ApkInfo
  attr_accessor :package_name
  attr_accessor :label
  attr_accessor :version_name
  attr_accessor :version_code
  attr_accessor :min_sdk_version
  attr_accessor :target_sdk_version
  attr_accessor :screen_support
  attr_accessor :permissions
  attr_accessor :icons

  def initialize
    @screen_support = ScreenSupport.new
    @permissions = []
    @icons = []
  end
end