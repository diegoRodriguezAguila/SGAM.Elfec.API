class UserGroup < ActiveRecord::Base
  enum status: [:disabled, :enabled]
  validates_presence_of :name, :description, :status
  validates_uniqueness_of :name
end
