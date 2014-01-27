class Api::MembershipApplicationsController < ApplicationController
  respond_to :json

  def index
    applications.fetch do | found | 
      render action: 'index', locals: { applications: found }
    end
  end

  def accept
    updater.update id, acceptance_params do | updated |
      render partial: '/api/membership_applications/membership_application', locals: { application: updated }
    end
  end

  def reject
    updater.update id, rejection_params do | updated |
      render partial: '/api/membership_applications/membership_application', locals: { application: updated }
    end
  end

  protected

  def applications
    ::Marina::Commands::Fetchers::MembershipApplicationsFetcher.new user: current_user, data_store: Marina::Db::Subscription::ReviewedPlan::Application
  end

  def updater
    ::Marina::Commands::Builders::MembershipApplicationUpdater.new user: current_user, data_store: Marina::Db::Subscription::ReviewedPlan::Application
  end

  def id
    params[:id]
  end

  def acceptance_params
    params.require(:application).permit(:reason_for_affiliate_rejection)
  end

  def rejection_params
    params.require(:application).permit(:reason_for_rejection)
  end
end
