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
end
