class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, join_table: :role_assignations
end
