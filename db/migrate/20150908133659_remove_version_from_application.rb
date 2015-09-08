class RemoveVersionFromApplication < ActiveRecord::Migration
  def change
    remove_column :applications, :version, :string
  end
end
