class AddForeignKeyToInstallations < ActiveRecord::Migration
  def change
    add_foreign_key :installations, :applications
    add_foreign_key :installations, :app_versions
    add_foreign_key :installations, :devices
  end
end
