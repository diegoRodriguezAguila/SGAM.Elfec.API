class CreateJoinTablePermissionRole < ActiveRecord::Migration
  def change
    create_join_table :permissions, :roles, table_name: :role_permissions do |t|
      t.timestamps null: false
      t.index [:permission_id, :role_id], name: 'permission_id_role_id_index', unique: true
      t.index [:role_id, :permission_id], name: 'role_id_permission_id_index', unique: true
    end
    add_foreign_key :role_permissions, :permissions
    add_foreign_key :role_permissions, :roles
  end
end
