class Application < ActiveRecord::Base
  validates_presence_of :name, :app_versions, :package, :url, :status
  validates_uniqueness_of :name, :package
  has_many :app_versions, dependent: :destroy
end
