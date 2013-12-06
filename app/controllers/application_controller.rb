class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_user
    @current_user ||= OpenStruct.new.tap do | u | 
      def u.can permission
        true
      end
    end
  end
end
