class Marina::Db::Subscription::ReviewedPlan < Marina::Db::Subscription::Plan 
  include Marina::Subscription::ReviewedPlan
  has_many :applications, class_name: '::Marina::Db::Subscription::ReviewedPlan::Application', foreign_key: 'plan_id', dependent: :destroy


  def auto_approval_code
    ::Marina::Application.config.auto_approval_code
  end
end
