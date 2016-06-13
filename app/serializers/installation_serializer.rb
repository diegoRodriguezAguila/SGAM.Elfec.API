class InstallationSerializer < ModelWithStatusSerializer
  include FileUrlHelper, ApkIconsHelper
  attributes :id, :app_name, :package, :version, :imei, :status
  self.root = false
  def attributes
    data = super
    hashids = Hashids.new(Rails.configuration.hashids.salt+:installation.to_s,
                          Rails.configuration.ids_length)
    data[:id] = hashids.encode(data[:id])
    data[:icon_url] = "#{application_version_res_url(options[:host],
                           data[:package], data[:version])}/#{APP_ICON_FILENAME}"
    data
  end
end
