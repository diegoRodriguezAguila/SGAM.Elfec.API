class CreateAppVersions < ActiveRecord::Migration
  def change
    create_table :app_versions do |t|
      t.belongs_to :application, index: true, null: false
      t.string :version, null: false
      t.text :url, null: false
      t.text :icon_url
      t.integer :version_code
      t.integer :status, null: false

      t.timestamps null: false
    end
  end
end
