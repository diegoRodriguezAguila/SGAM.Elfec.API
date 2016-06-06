class Application < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :package, :status
  validates_uniqueness_of :name, :package
  validates_format_of :package, with: /\A[a-z][a-z0-9_]*(\.[a-z0-9_]+)+[0-9a-z_]\z/i
  has_many :app_versions, -> { order(version: :desc, version_code: :desc) }, dependent: :destroy
  has_many :installations, dependent: :destroy

  # Obtiene la aplicacion utilizando el nombre de paquete,
  # si no existe crea una utilizando todos los atributos. Nota.-
  # este metodo no guarda la nueva instancia
  def self.find_or_create_instance(attrs={})
    p attrs
    new_app = find_by_package(attrs[:package]) # existe ya
    new_app = Application.new(attrs) if new_app.nil?
    p new_app
    new_app
  end

  # Obtiene la ultima version de la aplicación
  # @return [String]
  def latest_version
    update_latest_version_values
    read_attribute(:latest_version)
  end

  # Obtiene el version code de la última version de la aplicación
  # @return [Integer]
  def latest_version_code
    update_latest_version_values
    read_attribute(:latest_version_code)
  end

  # Verifica si la aplicación es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    user.has_permission? Permission.register_application
  end

  # Verifica si la aplicación es actualizable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def updatable_by? (user)
    user.has_permission? Permission.register_application
  end

  # Verifica si esta aplicación específica es visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user.has_permission? Permission.view_single_application
  end

  # Verifica si esta aplicación es descargable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def downloadable_by? (user)
    user.has_permission? Permission.download_application
  end

  # Verifica si el recurso de las aplicaciones son visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    return user.has_permission? Permission.view_applications
  end

  # Asigna los valores de la última version actual
  def update_latest_version_values(force_update=false)
    if @latest.nil? || force_update
      @latest = find_latest_version
      write_attribute(:latest_version, @latest.nil?? I18n.t(:'api.errors.application.undefined_version', :cascade => true) : @latest.version)
      write_attribute(:latest_version_code, @latest.nil?? I18n.t(:'api.errors.application.undefined_version', :cascade => true) : @latest.version_code)
      #self.save
    end
  end

  private


  def find_latest_version
    active_versions = app_versions.where(status: 1)
    return active_versions[0] if active_versions.size>0
    nil
  end

end
