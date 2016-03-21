class CreateEntityRules < ActiveRecord::Migration
  def change
    create_table :entity_rules do |t|
      t.references :entity, polymorphic: true, index:true
      t.belongs_to :rule, index: true
      t.timestamps null: false
    end
  end
end
