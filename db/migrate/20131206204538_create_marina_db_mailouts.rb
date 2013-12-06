class CreateMarinaDbMailouts < ActiveRecord::Migration
  def change
    create_table :marina_db_mailouts do |t|
      t.belongs_to :account
      t.belongs_to :sender
      t.string :subject, :from_address
      t.text :contents
      t.boolean :send_to_all_members, default: false
      t.text :recipient_plan_ids
      t.timestamps
    end

    add_index :marina_db_mailouts, :account_id
  end
end
