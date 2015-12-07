require 'pg'

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  extend MultiSortable
  # Include default devise modules. Others available are:
  include ActiveDirectoryUserHelper
  enum status: [:disabled, :enabled, :non_registered]
  devise :database_authenticatable, :trackable

  attr_accessor :password

  validates :username, presence: true, uniqueness: true
  validates :authentication_token, uniqueness: true

  has_and_belongs_to_many :roles, join_table: 'role_assignations'
  has_and_belongs_to_many :devices, join_table: 'user_devices'

  # Busca en la base el usuario en intenta logearlo es decir, que tiene que existir el usuario
  # a nivel de postgres
  # @param [String] password
  # @return [Boolean]
  def valid_password?(password)
    authenticate(username, password)
  end

  # Verifica si un usuario es creable por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def creatable_by? (user)
    user.has_permission?(Permission.register_user)
  end

  # Verifica si este usuario específico es visible por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def viewable_by? (user)
    user==self || user.has_permission?(Permission.view_single_user)
  end

  # Verifica si el recurso de los usuario son visibles por cierto usuario
  # @param [User] user
  # @return [Boolean]
  def self.are_viewable_by? (user)
    user.has_permission? Permission.view_users
  end

  # Retorna true si aun es valida la
  # ultima sincronizacion con active directory
  # @return [Boolean]
  def is_ad_sync_valid?
    last_ad_sync_at >= Time.now-24*60*60
  end

  # actualiza los atributos de activedirectory solo
  # si es necesario
  def update_ad_attributes!
    update(get_ad_user_attributes (params[:id])) unless is_ad_sync_valid?
  end

  # Verifica si es que el usuario tiene cierto permiso en alguno de sus roles
  # @param [Permission] permission
  # @return [Boolean]
  def has_permission?(permission)
    self.roles.each do |role|
      res = Permission.joins(:roles).where(roles:{ id: role.id}, permissions: {name: permission.name})
      if res.size > 0
        return true
      end
    end
    false
  end
end
