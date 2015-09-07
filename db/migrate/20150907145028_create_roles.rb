class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role, null: false
      t.text :description
      t.integer :status, null: false

      t.timestamps null: false
    end
  end
end
