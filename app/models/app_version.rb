class AppVersion < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  belongs_to :application
  validates :application, :version, :status, presence: true
  validates :version_code, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
  validate :version_already_exists

  after_save :update_application_version
  after_destroy :update_application_version

  private

  def version_already_exists
    application.app_versions.each do |app_ver|
      if app_ver!=self && app_ver.version==version
        errors.add(:version)
      end
    end
  end

  def update_application_version
    self.application.update_latest_version_values
  end
end
