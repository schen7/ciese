class Admin::PagesController < ApplicationController
  
  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @pages = Page.includes(:user).where(latest: true).order(url: :asc)
  end

  def new
    @page = Page.new(url: '/', content: "<h1>Title</h1>\n<p>Content here.</p>")
    render "editor"
  end

  def edit
    @page = Page.find_by(url: page_params[:url], latest: true)
    render "editor"
  end

  def create
    data = page_params.merge(user: current_user, latest: true)
    Page.where(url: data[:url]).update_all(latest: false)
    page = Page.new(data)
    if page.save
      render json: {saved: true}
    else
      render json: {saved: false, errors: page.errors.full_messages}
    end
  end

  private

  def page_params
    params.permit(:url, :content)
  end

end

