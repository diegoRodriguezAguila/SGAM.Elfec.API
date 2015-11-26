require 'pg'

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  include ActiveDirectoryUserHelper
  devise :database_authenticatable,
         :rememberable, :trackable

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
    puts "BEFORE AUTHENTICATION"
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
