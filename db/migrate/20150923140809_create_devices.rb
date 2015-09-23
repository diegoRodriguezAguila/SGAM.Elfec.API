class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name, unique: true
      t.string :imei, null: false, unique: true
      t.string :serial, null: false
      t.string :mac_address, null: false, unique: true
      t.string :platform, null: false, default: 'Android'
      t.string :os_version, null: false
      t.string :brand, null: false
      t.string :model, null: false
      t.decimal :screen_size
      t.string :screen_resolution
      t.decimal :camera
      t.decimal :sd_memory_card
      t.integer :status, null: false, default: 1

      t.timestamps null: false
    end
  end
end
