class Api::MailoutsController < ApplicationController
  respond_to :json

  def index
    render json: { mailouts: [] }
  end
end
