class Api::SubscriptionPlansController < ApplicationController
  respond_to :json

  def index
    plans.fetch do | found |
      render action: 'index', locals: { plans: found }
    end
  end

  protected

  def plans
    @plans ||= Marina::Commands::SubscriptionPlans.new user: current_user, store: Marina::Db::Subscription::Plan
  end
end
