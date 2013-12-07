class Api::MailoutsController < ApplicationController
  respond_to :json

  def index
    render json: { mailouts: [] }
  end

  def create
    mailout_builder.build_from mailout_params do | mailout |
      Delayed::Job.enqueue Marina::Commands::Jobs::MailoutSender.new(user: current_user, mailout_id: mailout.id)
      render partial: 'mailout', locals: { mailout: mailout }
    end
  end

  protected

  def mailouts_fetcher
    #@mailouts_fetcher ||= Marina::Commands::Fetchers::Mailouts.new user: current_user, data_store: current_account.mailouts
  end

  def mailout_params
    params.require(:mailout).permit(:subject, :contents, :from_address, :send_to_all_members, :test, { recipient_plan_ids: [] })
  end

  def mailout_builder
    @mailout_builder ||= Marina::Commands::Builders::MailoutsBuilder.new user: current_user, data_store: current_account.mailouts
  end
end
