class CreateMarinaDbLogEntries < ActiveRecord::Migration
  def change
    create_table :marina_db_log_entries do |t|
      t.belongs_to :owner
      t.string :owner_type, length: 128
      t.string :type, length: 128
      t.text :data, :message
      t.timestamps
    end
    add_index :marina_db_log_entries, [:owner_type, :owner_id, :created_at], name: 'log_entry_owner'
  end
end
