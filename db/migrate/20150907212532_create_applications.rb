class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string :name, null: false
      t.string :package, null: false
      t.string :latest_version, null:false, default: 'no asignada'
      t.text :url, null: false, default: 'no asignada'
      t.text :icon_url
      t.integer :status, null: false

      t.timestamps null: false
    end

    add_index :applications, :name
    add_index :applications, :package
  end
end
