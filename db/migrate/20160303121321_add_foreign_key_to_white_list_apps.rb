class AddForeignKeyToWhiteListApps < ActiveRecord::Migration
  def change
    add_foreign_key :whitelist_apps, :whitelists
  end
end
