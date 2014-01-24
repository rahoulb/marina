class Marina::Db::Subscription::ReviewedPlan < Marina::Db::Subscription::Plan 
  has_many :applications, class_name: '::Marina::Db::Subscription::ReviewedPlan::Application', foreign_key: 'plan_id', dependent: :destroy

  # params: supporting_information
  def record_application_for member, params = {}
    applications.create! member: member, supporting_information: params[:supporting_information]
  end

end
