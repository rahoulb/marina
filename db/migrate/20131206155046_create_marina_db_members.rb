class CreateMarinaDbMembers < ActiveRecord::Migration
  def change
    create_table :marina_db_members do |t|
      t.belongs_to :site
      t.string :first_name, :last_name, :email, length: 128
      t.boolean :receives_mailshots, default: false, null: false
      t.timestamps
    end
    add_index :marina_db_members, [:site_id, :email]
    add_index :marina_db_members, [:site_id, :last_name]
  end
end
