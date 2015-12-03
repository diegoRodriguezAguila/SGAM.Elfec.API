class AppVersionSerializer < ModelWithStatusSerializer
  include FileUrlHelper, ApkIconsHelper
  attributes :version, :version_code, :status
  def attributes
    data = super
    data[:url] = "#{application_version_url(options[:host], options[:package], data[:version])}?d"
    data[:icon_url] = "#{application_version_res_url(options[:host], options[:package], data[:version])}/#{APP_ICON_FILENAME}"
    data
  end
end
