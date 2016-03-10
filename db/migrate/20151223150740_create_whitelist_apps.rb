class CreateWhitelistApps < ActiveRecord::Migration
  def change
    create_table :whitelist_apps do |t|
      t.belongs_to :whitelist, index: true, null: false
      t.string :package, null: false, unique: true
      t.integer :status, null: false, default: 1

      t.timestamps null: false
    end
    add_index :whitelist_apps, :package
  end
end
