class Application < ActiveRecord::Base
  validates_presence_of :name, :version, :package, :url, :status
end
