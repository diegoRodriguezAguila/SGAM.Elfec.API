class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.string :type
      t.string :name
      t.text :description
      t.integer :status, null: false, default: 1
      t.timestamps null: false
    end
  end
end
