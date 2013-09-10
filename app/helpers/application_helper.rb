module ApplicationHelper

  def full_title(page_title)
    base_title = "CIESE"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def not_found
    raise ActionController::RoutingError.new('Page Not Found')
  end

  def not_authorized
    raise User::NotAuthorized
  end
end
