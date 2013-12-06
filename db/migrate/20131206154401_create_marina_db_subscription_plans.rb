class CreateMarinaDbSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :marina_db_subscription_plans do |t|
      t.string :type
      t.string :name, length: 128, null: false

      t.timestamps
    end
    add_index :marina_db_subscription_plans, :name, unique: true
  end
end
