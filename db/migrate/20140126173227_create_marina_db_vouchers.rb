class CreateMarinaDbVouchers < ActiveRecord::Migration
  def change
    create_table :marina_db_vouchers do |t|
      t.belongs_to :site
      t.string :code, length: 64, default: '', null: false
      t.string :type
      t.integer :days
      t.decimal :amount, precision: 8, scale: 2
      t.timestamps
    end

    add_index :marina_db_vouchers, [:site_id, :code]
  end
end
