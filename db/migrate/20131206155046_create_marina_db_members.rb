class CreateMarinaDbMembers < ActiveRecord::Migration
  def change
    create_table :marina_db_members do |t|
      t.belongs_to :site
      t.string :username, :first_name, :last_name, :email, length: 128
      t.string :encrypted_password, length: 256
      t.string :api_token, length: 64
      t.boolean :receives_mailshots, default: false, null: false
      t.boolean :admin, default: false, null: false
      t.timestamps
    end
    add_index :marina_db_members, [:site_id, :username]
    add_index :marina_db_members, [:site_id, :email]
    add_index :marina_db_members, [:site_id, :last_name]
    add_index :marina_db_members, [:site_id, :api_token], unique: true
  end
end
