class Api::SubscriptionPlansController < ApplicationController
  respond_to :json

  def index
    plans.fetch do | found |
      render action: 'index', locals: { plans: found }
    end
  end

  protected

  def plans
    @plans ||= Marina::Commands::Fetchers::SubscriptionPlans.new user: current_user, data_store: current_account.subscription_plans
  end
end
