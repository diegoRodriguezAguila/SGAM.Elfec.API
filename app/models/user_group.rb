class UserGroup < ApplicationRecord
  enum status: [:disabled, :enabled, :sealed]
  validates_presence_of :name, :status
  validates_presence_of :description, unless: Proc.new { |ug| ug.sealed? }
  validates_uniqueness_of :name


  has_and_belongs_to_many :members,-> { order(status: :desc, username: :asc) }, class_name: 'User', join_table: 'user_group_members'
  has_many :entity_rules, as: :entity

  # Define el identificador del tipo de entidad que es
  def entity_type
    self.class.name
  end

  # Obtiene el grupo de usuarios: todos los usuarios
  # @return [UserGroup]
  def self.all_users_group
    find_or_create_by(name: 'Todos los usuarios', status: statuses[:sealed])
  end

  # Verifica si este grupo de usuarios es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    user.has_permission?(Permission.register_user_group) && !sealed?
  end
  # Verifica si el grupo de usuarios es updateable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def updatable_by? (user)
    user.has_permission?(Permission.update_user_group) && !sealed?
  end
  # Verifica si este grupo de usuarios específico esn visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user.has_permission? Permission.view_user_groups
  end

  # Verifica si el recurso de los grupos de usuarios son visibles por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    user.has_permission? Permission.view_single_user_group
  end
end
