include ApplicationHelper

def log_in(user)
  visit login_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Log In"
end

def log_in_and_visit(user, path)
  log_in user
  visit path
end

def page_not_found_message
  "The page you were looking for doesn't exist."
end

def not_authorized_message
  "You are not authorized to access this page."
end



