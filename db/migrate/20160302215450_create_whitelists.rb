class CreateWhitelists < ActiveRecord::Migration
  def change
    create_table :whitelists do |t|
      t.string :title
      t.text :description
      t.integer :status, null: false, default: 1
      t.timestamps null: false
    end
    add_index :whitelists, :title, unique: true
  end
end
