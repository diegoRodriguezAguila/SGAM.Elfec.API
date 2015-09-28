class AddIndexToDevices < ActiveRecord::Migration
  def change
    add_index :devices, :imei, unique: true
  end
end
