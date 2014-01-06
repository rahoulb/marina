class Public::RegistrationsController < ApplicationController
  def new
    render action: 'new', locals: { subscription_plan: subscription_plan }
  end

  protected

  def subscription_plan
    @subscription_plan ||= Marina::Db::Subscription::Plan.find params[:subscription_plan_id]
  end
end
