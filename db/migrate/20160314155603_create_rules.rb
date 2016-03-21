class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.belongs_to :policy, index: true, null: false
      t.string :type
      t.string :name
      t.text :description
      t.string :value
      t.string :exception

      t.integer :status, null: false, default: 1
      t.timestamps null: false
    end
    add_foreign_key :rules, :policies
  end
end
