class Api::SessionsController < ApplicationController
  def new
    self.create
    # nasty - using a GET to do a login action, but it makes the PHP wordpress plugin a bit easier
  end

  def create
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
