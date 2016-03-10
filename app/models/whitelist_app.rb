class WhitelistApp < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  belongs_to :whitelist
  validates_presence_of :package, :status
  validates :package, uniqueness: { scope: :whitelist}
  validates_format_of :package, with: /\A[a-z][a-z0-9_]*(\.[a-z0-9_]+)+[0-9a-z_]\z/i
end
