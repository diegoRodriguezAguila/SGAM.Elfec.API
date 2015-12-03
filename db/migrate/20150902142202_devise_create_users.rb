class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :username,              null: false, default: ''
      t.string :authentication_token
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :position
      t.string :company_area

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      t.datetime :last_ad_sync_at, null: false
      t.integer :status, null: false
      t.timestamps null: false
    end

    add_index :users, :username,                unique: true
    add_index :users, :authentication_token,    unique: true
  end
end
