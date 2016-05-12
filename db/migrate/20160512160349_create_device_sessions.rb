class CreateDeviceSessions < ActiveRecord::Migration
  def change
    create_table :device_sessions do |t|
      t.belongs_to :user, index: true, null: false
      t.belongs_to :device, index: true, null: false
      t.string :username, null: false
      t.string :imei, null: false
      t.string :status, null: false, default: DeviceSession.statuses[:opened]

      t.timestamps null: false
    end
    add_foreign_key :device_sessions, :users
    add_foreign_key :device_sessions, :devices
  end
end
