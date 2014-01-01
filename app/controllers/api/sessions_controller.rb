class Api::SessionsController < ApplicationController
  def new
    authenticator.authenticate(params[:username], params[:password]) do | found |
      session[:user_id] = found.id
      render action: 'show', locals: { member: found }
    end
  end

  protected

  def authenticator
    @authenticator ||= Marina::Commands::Fetchers::Authenticator.new members: Marina::Db::Member
  end
end
