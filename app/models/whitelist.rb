class Whitelist < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :title, :description, :status
  validates_uniqueness_of :title
  has_many :permitted_apps, class_name: 'WhitelistApp', foreign_key: :whitelist_id

  # Verifica si este whitelist es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    user.has_permission? Permission.register_whitelist
  end
  # Verifica si el whitelist es updateable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def updatable_by? (user)
    user.has_permission? Permission.update_whitelist
  end
  # Verifica si este whitelist específico esn visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user.has_permission? Permission.view_whitelists
  end

  # Verifica si el recurso de los grupos de usuarios son visibles por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    user.has_permission? Permission.view_single_whitelist
  end
  
end
