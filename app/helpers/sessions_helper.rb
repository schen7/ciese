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
  
  def redirect_back_or(default_path)
    redirect_to(session[:return_to] || default_path)
    session.delete(:return_to)
  end
  
  def store_current_path
    session[:return_to] = request.url
  end
  
  def require_login
    unless logged_in?
      store_current_path
      redirect_to login_path
    end
  end

  def require_admin
    not_authorized unless current_user && current_user.active? && current_user.admin?
  end
end
