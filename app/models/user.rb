class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :rememberable, :trackable

  attr_accessor :password

  def valid_password?(password)
    false #TODO validate on database presence of user and connectivity
  end

  validates_presence_of :username
  validates_uniqueness_of :username
end
