class WhitelistApp < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :package, :status
  validates_uniqueness_of :package
  belongs_to :whitelist
end
