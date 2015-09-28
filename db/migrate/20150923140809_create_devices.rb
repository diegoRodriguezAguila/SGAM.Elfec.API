class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :name, unique: true
      t.string :imei, null: false, unique: true
      t.string :serial, null: false
      t.string :wifi_mac_address, null: false, unique: true
      t.string :bluetooth_mac_address, null: false, unique: true
      t.string :platform, null: false, default: 'Android'
      t.string :os_version, null: false
      t.string :baseband_version, null: false
      t.string :brand, null: false
      t.string :model, null: false
      t.string :phone_number
      t.string :id_cisco_asa
      t.decimal :screen_size
      t.string :screen_resolution
      t.decimal :camera
      t.decimal :sd_memory_card
      t.string :gmail_account
      t.text :comments
      t.integer :status, null: false, default: 2

      t.timestamps null: false
    end
  end
end
