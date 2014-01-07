class Api::PinPaymentNotificationsController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    subscriber_ids.each do | id |
      Delayed::Job.enqueue Marina::Commands::Jobs::PinPaymentSubscriberDetailsJob.new(id)
    end
    render text: 'OK', status: 200
  end

  protected

  def subscriber_ids
    params[:subscriber_ids] || []
  end
end
