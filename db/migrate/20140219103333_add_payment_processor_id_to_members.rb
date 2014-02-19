class AddPaymentProcessorIdToMembers < ActiveRecord::Migration
  def change
    add_column :marina_db_members, :payment_processor_id, :integer, default: nil
  end
end
