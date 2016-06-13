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
  validate :status_changes
  validate :version_changes

  def app_name
    application.nil? ? nil : application.name
  end

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
      errors.add(:app_version, "tiene que ser una version de la aplicación #{application.package}")
    end
  end

  def status_changes
    if changes.key?(:app_version_id) && changes.key?(:status) && self.uninstall_pending?
      errors.add(:app_version,
                 "no puede cambiar si se cambia el estado de la instalación a #{self.status}")
    end
  end

  def version_changes
    if changes.key?(:app_version_id)
      app_version_was = AppVersion.find_by_id(app_version_id_was)
      if app_version_was.version>self.app_version.version ||
          app_version_was.version_code>self.app_version.version_code
        errors.add(:app_version, 'no puede ser menor a la version instalada actual')
      end
    end
  end
end
