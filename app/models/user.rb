require 'pg'

class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable

  attr_accessor :password

  validates :username, presence: true, uniqueness: true
  validates :authentication_token, uniqueness: true

  # Busca en la base el usuario en intenta logearlo es decir, que tiene que existir el usuario
  # a nivel de postgres
  # @param [String] password
  # @return [Boolean]
  def valid_password?(password)
    config = Rails.configuration.database_configuration[Rails.env]
    begin
    conn = PG::Connection.new(:dbname=>config['database'],
                              :port=>config['port'],
                              :host=>config['host'],
                              :user=>self.username,
                              :password=>password)
    rescue PG::ConnectionBad
      false
    else
      conn.close unless conn.nil?
      self.password = password
      true
    end
  end
end
