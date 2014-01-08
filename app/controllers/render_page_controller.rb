class RenderPageController < ApplicationController

  def show
    @page = Page.joins(:published_page).find_by(url: "/#{params[:url]}") || not_found
  end

end

