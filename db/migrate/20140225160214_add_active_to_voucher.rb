class AddActiveToVoucher < ActiveRecord::Migration
  def change
    add_column :marina_db_vouchers, :active, :boolean, default: true
  end
end
