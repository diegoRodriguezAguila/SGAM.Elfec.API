require 'pg'

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  devise :database_authenticatable,
         :rememberable, :trackable

  attr_accessor :password

  validates :username, presence: true, uniqueness: true
  validates :authentication_token, uniqueness: true

  has_and_belongs_to_many :roles, join_table: :role_assignations

  # Busca en la base el usuario en intenta logearlo es decir, que tiene que existir el usuario
  # a nivel de postgres
  # @param [String] password
  # @return [Boolean]
  def valid_password?(password)
    config = Rails.configuration.database_configuration[Rails.env]
    begin
      conn = PG::Connection.new(:dbname => config['database'],
                                :port => config['port'],
                                :host => config['host'],
                                :user => self.username,
                                :password => password)
    rescue PG::ConnectionBad
      false
    else
      conn.close unless conn.nil?
      self.password = password
      true
    end
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
