class Application < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :package, :latest_version, :url, :status
  validates_uniqueness_of :name, :package
  has_many :app_versions, -> { order(version: :desc) }, dependent: :destroy

  # Verifica si esta aplicaci�n espec�fica es visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    return user.has_permission? Permission.view_single_application
  end

  # Verifica si el recurso de las aplicaciones son visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    return user.has_permission? Permission.view_applications
  end

  # Asigna los valores de la �ltima version actual
  def update_latest_version_values
    latest = find_latest_version
    if (!latest.nil?)
      self.url = latest.url
      self.icon_url = latest.icon_url
      self.latest_version =latest.version
      save
    end
  end

  private

  def find_latest_version
    active_versions = app_versions.where(status: 1)
    if (active_versions.size>0)
      return active_versions[0]
    end
    return nil
  end

end
