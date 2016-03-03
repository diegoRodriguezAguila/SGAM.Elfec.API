class Whitelist < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :title, :description, :status
  validates_uniqueness_of :title
  has_many :permitted_apps, class_name: 'WhitelistApp', foreign_key: :whitelist_id
end
