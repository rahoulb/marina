class AddPlanUrlToPlans < ActiveRecord::Migration
  def change
    add_column :marina_db_subscription_plans, :plan_url, :string
  end
end
