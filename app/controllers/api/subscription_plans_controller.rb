class Api::SubscriptionPlansController < ApplicationController
  respond_to :json

  def index
    plans.fetch do | found |
      render action: 'index', locals: { plans: found }
    end
  end

  def create
    plan_builder.build_from plan_params do | created |
      render partial: 'plan', locals: { plan: created }
    end
  end

  def update
    plan_builder.update params[:id], plan_params do | updated |
      render partial: 'plan', locals: { plan: updated }
    end
  end

  protected

  def plans
    @plans ||= Marina::Commands::Fetchers::SubscriptionPlans.new user: current_user, data_store: current_account.subscription_plans
  end

  def plan_builder
    @plan_builder ||= Marina::Commands::Builders::SubscriptionPlanBuilder.new user: current_user, data_store: current_account.subscription_plans
  end

  def plan_params
    params.require(:plan).permit(:name, :type, :active, :price, :length, :supporting_information_label, :supporting_information_description, :active)
  end
end
