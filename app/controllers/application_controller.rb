class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_user
    @current_user ||= Marina::Db::Member.first  
  end

  def current_account
    @current_account ||= OpenStruct.new.tap do | a |
      a.subscription_plans = Marina::Db::Subscription::Plan
      a.mailouts = Marina::Db::Mailout
    end
  end
end
