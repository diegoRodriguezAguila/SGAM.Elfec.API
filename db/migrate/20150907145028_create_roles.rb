class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role
      t.string :description
      t.integer :status

      t.timestamps null: false
    end
  end
end
