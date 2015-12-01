class AppVersionSerializer < ModelWithStatusSerializer
  include FileUrlHelper
  attributes :version, :version_code, :status
  def attributes
    data = super
    data[:url] = "#{application_version_url(options[:host], options[:package], data[:version])}?d"
    data[:icon_url] = "#{application_version_res_url(options[:host], options[:package], data[:version])}/icon.png"
    data
  end
end
