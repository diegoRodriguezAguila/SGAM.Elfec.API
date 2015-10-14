class ApplicationSerializer < ModelWithStatusSerializer
  attributes  :name, :package, :url, :app_versions,:status
  has_many :app_versions
  self.root = false

end