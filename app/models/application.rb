class Application < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :package, :status
  validates_uniqueness_of :name, :package
  has_many :app_versions, -> { order(version: :desc) }, dependent: :destroy

  def latest_version
    update_latest_version_values
    @latest.nil?? I18n.t(:'api.errors.application.undefined_version', :cascade => true) :@latest.version
  end

  def url
    update_latest_version_values
    @latest.nil?? I18n.t(:'api.errors.application.undefined_url', :cascade => true) :@latest.url
  end

  def icon_url
    update_latest_version_values
    @latest.nil?? nil :@latest.icon_url
  end

  # Verifica si esta aplicación específica es visible por cierto usuario
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

  # Asigna los valores de la última version actual
  def update_latest_version_values
    if (@latest.nil?)
      @latest = find_latest_version
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
