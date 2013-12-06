class CreateMarinaDbMembers < ActiveRecord::Migration
  def change
    create_table :marina_db_members do |t|
      t.string :first_name, :last_name, :email, length: 128
      t.boolean :receives_mailshots, default: false, null: false
      t.timestamps
    end
    add_index :marina_db_members, :email
    add_index :marina_db_members, :last_name
  end
end
