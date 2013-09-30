module SessionsHelper

  def log_in(user)
    cookies[:login_token] = { value: user.login_token, httponly: true }
    self.current_user = user
  end

  def log_out
    cookies.delete(:login_token)
    self.current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(login_token: cookies[:login_token])
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def user_staff?
    current_user && current_user.active? && current_user.staff?
  end

  def user_admin?
    current_user && current_user.active? && current_user.admin?
  end

  def user_staff_or_admin?
    current_user && current_user.active? &&
    (current_user.staff?  || current_user.admin?)
  end
  
  def redirect_back_or(default_path)
    redirect_to(session[:return_to] || default_path)
    session.delete(:return_to)
  end
  
  def store_current_path
    session[:return_to] = request.url
  end

  def require_login
    not_logged_in unless logged_in?
  end

  def require_staff
    not_authorized unless user_staff?
  end

  def require_admin
    not_authorized unless user_admin?
  end

  def require_staff_or_admin
    not_authorized unless user_staff_or_admin?
  end

  def api_require_login
    not_logged_in("api") unless logged_in?
  end

  def api_require_staff
    not_authorized("api") unless user_staff?
  end

  def api_require_admin
    not_authorized("api") unless user_admin?
  end

  def api_require_staff_or_admin
    not_authorized("api") unless user_staff_or_admin?
  end

end
