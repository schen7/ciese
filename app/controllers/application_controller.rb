class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :set_csrf_cookie_for_ng
  
  rescue_from User::NotLoggedIn, with: :handle_not_logged_in
  rescue_from User::NotAuthorized, with: :handle_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :render_404_page
  rescue_from ActionController::RoutingError, with: :render_404_page
  rescue_from ActiveRecord::RecordInvalid, with: :render_500_page

  protected

  include SessionsHelper
  
  def not_found
    raise ActionController::RoutingError.new('Page Not Found')
  end

  def not_authorized(access_method="page")
    raise User::NotAuthorized, access_method
  end

  def not_logged_in(access_method="page")
    raise User::NotLoggedIn, access_method
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
  
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  private

  def handle_not_logged_in(exception)
    if exception.message == "api"
      render json: {"error" => "Login required."} , status: 403
    else
      store_current_path
      redirect_to login_path
    end
  end

  def handle_not_authorized(exception)
    if exception.message == "api"
      render json: {"error" => "Not authorized."}, status: 403
    else
      render_403_page
    end
  end
  
  def render_403_page
    render "static_pages/403.html", status: 403
  end

  def render_404_page
    render "static_pages/404.html", status: 404
  end
  
  def render_500_page
    render "static_pages/500.html", status: 500
  end
end
