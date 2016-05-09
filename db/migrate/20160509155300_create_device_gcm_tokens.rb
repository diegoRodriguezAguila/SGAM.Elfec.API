class CreateDeviceGcmTokens < ActiveRecord::Migration
  def change
    create_table :device_gcm_tokens do |t|
      t.belongs_to :device, index: true, null: false
      t.string :token

      t.timestamps null: false
    end
    add_foreign_key :device_gcm_tokens, :devices
  end
end
