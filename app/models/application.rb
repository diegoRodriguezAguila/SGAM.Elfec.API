class Application < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :package, :status
  validates_uniqueness_of :name, :package
  has_many :app_versions, -> { order(version: :desc) }, dependent: :destroy

  def latest_version
    update_latest_version_values
    read_attribute(:latest_version)
  end

  # Verifica si la aplicaci�n es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    return user.has_permission? Permission.register_application
  end

  # Verifica si esta aplicaci�n espec�fica es visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    return user.has_permission? Permission.view_single_application
  end

  # Verifica si esta aplicaci�n es descargable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def downloadable_by? (user)
    return user.has_permission? Permission.download_application
  end

  # Verifica si el recurso de las aplicaciones son visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    return user.has_permission? Permission.view_applications
  end

  # Asigna los valores de la �ltima version actual
  def update_latest_version_values
    if (@latest.nil?)
      @latest = find_latest_version
      write_attribute(:latest_version, @latest.nil?? I18n.t(:'api.errors.application.undefined_version', :cascade => true) : @latest.version)
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
