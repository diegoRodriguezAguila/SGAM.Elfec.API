class AppVersion < ApplicationRecord
  enum status: [:disabled, :enabled]
  belongs_to :application
  validates :application, :version, :status, presence: true
  validates :version_code, numericality: {greater_than_or_equal_to: 0}
  validates :version, uniqueness: { scope: [:application, :version_code]}

  after_save :update_application_version
  after_destroy :update_application_version

  private

  def update_application_version
    self.application.update_latest_version_values(true)
  end
end
