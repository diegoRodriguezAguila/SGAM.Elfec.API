class CreateWhitelistApps < ActiveRecord::Migration
  def change
    create_table :whitelist_apps do |t|
      t.string :package, null: false, unique: true
      t.integer :status, null: false

      t.timestamps null: false
    end
    add_index :whitelist_apps, :package
  end
end