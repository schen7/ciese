class Admin::PagesController < ApplicationController
  
  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @pages = Page.includes(:user, :published_page)
  end

  def new
  end

end

