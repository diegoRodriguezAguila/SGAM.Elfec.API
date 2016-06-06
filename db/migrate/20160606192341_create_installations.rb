class CreateInstallations < ActiveRecord::Migration
  def change
    create_table :installations do |t|
      t.belongs_to :application, index: true
      t.belongs_to :app_version, index: true
      t.belongs_to :device, index: true
      t.string :version
      t.string :status, null: false, index: true
      t.timestamps null: false
    end
  end
end
