class CreateJoinTableDeviceUser < ActiveRecord::Migration
  def change
    create_join_table :devices, :users, table_name: :user_devices  do |t|
      t.timestamps null: false
      t.index [:device_id, :user_id]
      t.index [:user_id, :device_id]
    end
  end
end
