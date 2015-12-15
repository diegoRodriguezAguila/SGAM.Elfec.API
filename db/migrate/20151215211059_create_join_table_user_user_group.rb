class CreateJoinTableUserUserGroup < ActiveRecord::Migration
  def change
    create_join_table :users, :user_groups, table_name: :user_group_members do |t|
      t.timestamps null: false
      t.index [:user_id, :user_group_id], name: 'user_id_user_group_id_index', unique: true
      t.index [:user_group_id, :user_id], name: 'user_group_id_user_id_index', unique: true
    end
    add_foreign_key :user_group_members, :users
    add_foreign_key :user_group_members, :user_groups
  end
end
