class CreateJoinTableRoleUser < ActiveRecord::Migration
  def change
    create_join_table :roles, :users, table_name: :role_assignations do |t|
      t.index [:role_id, :user_id]
      t.index [:user_id, :role_id]
    end
  end
end
