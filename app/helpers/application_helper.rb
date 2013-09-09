module ApplicationHelper

  def full_title(page_title)
    base_title = "CIESE"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def login(user)
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Log In"
  end
end
