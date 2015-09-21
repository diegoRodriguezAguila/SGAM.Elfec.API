class Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles, join_table: :role_permissions
  validates :name, presence: true, uniqueness: true
  validates :status, presence: true
end
