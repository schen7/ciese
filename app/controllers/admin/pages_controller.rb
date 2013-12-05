class Admin::PagesController < ApplicationController
  
  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @pages = Page.includes(:user).where(latest: true).order(url: :asc)
  end

  def new
  end

end

