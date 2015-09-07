class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :role_assignations

  validates :role, presence: true, uniqueness: true
  validates :status, presence: true
end
