class AppVersionSerializer < ModelWithStatusSerializer
  attributes :version, :url, :icon_url, :status
end
