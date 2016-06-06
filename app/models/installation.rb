class Installation < ActiveRecord::Base
  enum status: {install_pending: 'install_pending',
                installed: 'installed',
                uninstall_pending: 'uninstall_pending',
                uninstalled: 'uninstalled'}
  belongs_to :application
  belongs_to :app_version
  belongs_to :device
  validates :application, :app_version, :device, :version, :status, presence: true
  validates :application, uniqueness: {scope: :device}
  validate :app_and_version_match

  def package
    application.nil? ? nil : application.package
  end

  def version
    app_version.nil? ? nil : app_version.version
  end

  def imei
    device.nil? ? nil : device.imei
  end

  private
  def app_and_version_match
    if app_version.application != application
      errors.add(:app_version, "tiene que ser una version de la aplicación "+application.package)
    end
  end
end
