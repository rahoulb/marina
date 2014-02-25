class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Marina::Commands::Unauthorised, with: :unauthorised
  rescue_from ActiveRecord::RecordInvalid, with: :invalid
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def authenticator
    @authenticator ||= Marina::Application.config.authenticator_class.constantize.new
  end

  def current_user_id
    authenticator.user_id_from request, session, cookies
  end

  def current_user
    @current_user ||= Marina::Db::Member.where(id: current_user_id).first
  end

  def current_account
    @current_account ||= OpenStruct.new.tap do | a |
      a.subscription_plans = Marina::Db::Subscription::Plan
      a.mailouts = Marina::Db::Mailout
    end
  end

  def unauthorised
    respond_to do | format | 
      format.html { render file: '401.html', status: 401 }
      format.json { render json: 'Insufficient security clearance', status: 401 }
    end
  end

  def invalid exception
    Rails.logger.error "ERROR 422: #{exception.message }"
    respond_to do | format |
      format.html { render file: '500.html', status: 422 }
      format.json { render json: exception.message, status: 422 }
    end
  end

  def not_found
    respond_to do | format |
      format.html { render file: '404.html', status: 404 }
      format.json { render json: 'Not found', status: 404 }
    end
  end
end
