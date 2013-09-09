class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from User::NotAuthorized, with: :user_not_authorized
  
  private
  
  def record_not_found
    render text: "404 Not Found", status: 404
  end
  
  def user_not_authorized
    flash[:error] = "You don't have access to this section."
    redirect_to :back
    
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
end
