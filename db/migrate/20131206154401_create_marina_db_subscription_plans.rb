class CreateMarinaDbSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :marina_db_subscription_plans do |t|
      t.belongs_to :site
      t.string :type
      t.string :name, length: 128, null: false
      t.decimal :price, precision: 10, scale: 2
      t.integer :length
      t.string :supporting_information_label
      t.text :supporting_information_description
      t.boolean :active, default: true, null: false
      t.timestamps
    end
    add_index :marina_db_subscription_plans, [:site_id, :name], unique: true
  end
end
