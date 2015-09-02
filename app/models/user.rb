class User < ActiveRecord::Base
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable

  attr_accessor :password

  validates :username, presence: true, uniqueness: true
  validates :authentication_token, uniqueness: true

  def valid_password?(password)
    false #TODO validate on database presence of user and connectivity
  end

end
