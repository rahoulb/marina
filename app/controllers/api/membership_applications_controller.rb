class Api::MembershipApplicationsController < ApplicationController
  respond_to :json

  def index
    applications.fetch do | found | 
      render action: 'index', locals: { applications: found }
    end
  end

  def accept
    updater.accept id, acceptance_params do | updated |
      render partial: '/api/membership_applications/application', locals: { application: updated }
    end
  end

  def reject
    updater.reject id, rejection_params do | updated |
      render partial: '/api/membership_applications/application', locals: { application: updated }
    end
  end

  protected

  def applications
    ::Marina::Commands::Fetchers::MembershipApplicationsFetcher.new user: current_user, data_store: Marina::Db::Subscription::ReviewedPlan::Application
  end

  def updater
    ::Marina::Commands::Builders::MembershipApplicationUpdater.new user: current_user, data_store: Marina::Db::Subscription::ReviewedPlan::Application, mail_processor: Marina::Application.config.mailing_list_processor, payment_processor: Marina::Application.config.payment_processor
  end

  def id
    params[:id]
  end

  def acceptance_params
    params.require(:application).permit(:reason_for_affiliation_rejection)
  end

  def rejection_params
    params.require(:application).permit(:reason_for_rejection)
  end
end
