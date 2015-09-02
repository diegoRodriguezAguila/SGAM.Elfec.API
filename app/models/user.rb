class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable

  attr_accessor :password

  validates :username, presence: true, uniqueness: true
  validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!

  def valid_password?(password)
    false #TODO validate on database presence of user and connectivity
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end


end
