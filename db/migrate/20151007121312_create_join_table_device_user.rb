class CreateJoinTableDeviceUser < ActiveRecord::Migration
  def change
    create_join_table :devices, :users, table_name: :user_devices  do |t|
      t.timestamps null: false
      t.index [:device_id, :user_id], unique: true
      t.index [:user_id, :device_id], unique: true
    end
    add_foreign_key :user_devices, :devices
    add_foreign_key :user_devices, :users
  end
end
