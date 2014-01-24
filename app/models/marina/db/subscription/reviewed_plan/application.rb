class Marina::Db::Subscription::ReviewedPlan::Application < ActiveRecord::Base
  include Marina::Subscription::Plan::Application

  self.table_name = 'marina_db_subscription_reviewed_plan_applications'

  belongs_to :plan, class_name: 'Marina::Db::Subscription::ReviewedPlan', foreign_key: 'plan_id', touch: true
  belongs_to :member, class_name: 'Marina::Db::Member', foreign_key: 'member_id', touch: true
  belongs_to :administrator, class_name: 'Marina::Db::Member', foreign_key: 'administrator_id'

end
