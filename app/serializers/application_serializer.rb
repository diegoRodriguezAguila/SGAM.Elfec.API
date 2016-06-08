class ApplicationSerializer < ModelWithStatusSerializer
  include FileUrlHelper, ApkIconsHelper
  attributes  :name, :package, :latest_version, :latest_version_code, :app_versions,:status
  has_many :app_versions
  self.root = false

  def attributes
    data = super
    options[:package] = data[:package]
    data[:url] = "#{application_url(options[:host], data[:package])}?d"
    data[:icon_url] = "#{application_res_url(options[:host], data[:package])}/#{APP_ICON_FILENAME}"
    data
  end

  def include_app_versions?
    !options[:include].nil? && options[:include].include?('app_versions')
  end
end