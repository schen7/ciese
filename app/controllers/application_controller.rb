class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  rescue_from User::NotAuthorized, with: :render_401_page
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_page
  rescue_from ActionController::RoutingError, with: :render_404_page
  rescue_from ActiveRecord::RecordNotFound, with: :render_500_page
  
  private
  
  def render_401_page
    render "static_pages/401.html", status: 401
  end

  def render_404_page
    render "static_pages/404.html", status: 404
  end
  
  def render_500_page
    render "static_pages/500.html", status: 500
  end
end
