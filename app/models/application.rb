class Application < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :app_versions, :package, :url, :status
  validates_uniqueness_of :name, :package
  has_many :app_versions, dependent: :destroy

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


end
