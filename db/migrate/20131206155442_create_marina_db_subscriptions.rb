class CreateMarinaDbSubscriptions < ActiveRecord::Migration
  def change
    create_table :marina_db_subscriptions do |t|
      t.belongs_to :plan
      t.belongs_to :member
      t.boolean :active, default: false, null: false
      t.date :expires_on
      t.timestamps
    end

    add_index :marina_db_subscriptions, :plan_id
    add_index :marina_db_subscriptions, :member_id
  end
end
