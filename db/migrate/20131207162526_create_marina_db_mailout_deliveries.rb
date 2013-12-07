class CreateMarinaDbMailoutDeliveries < ActiveRecord::Migration
  def change
    create_table :marina_db_mailout_deliveries do |t|
      t.belongs_to :mailout
      t.belongs_to :member
      t.timestamps
    end
    add_index :marina_db_mailout_deliveries, :mailout_id
    add_index :marina_db_mailout_deliveries, :member_id
  end
end
