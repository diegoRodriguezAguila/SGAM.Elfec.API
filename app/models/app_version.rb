class AppVersion < ActiveRecord::Base
  belongs_to :application

  validates :application, :version, :status,  presence: true
  validates :version_code, numericality: { greater_than_or_equal_to: 0 },
            presence: true
end
