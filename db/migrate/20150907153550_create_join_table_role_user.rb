class CreateJoinTableRoleUser < ActiveRecord::Migration
  def change
    create_join_table :roles, :users, table_name: :role_assignations do |t|
      t.timestamps null: false
      t.index [:role_id, :user_id], unique: true
      t.index [:user_id, :role_id], unique: true
    end
    add_foreign_key :role_assignations, :roles
    add_foreign_key :role_assignations, :users
  end
end
