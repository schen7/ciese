class Admin::PagesController < ApplicationController
  
  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @pages = CurrentPage.with_publish_info.joins(:version).includes(version: [:user]).order("pages.url ASC")
    render layout: "admin"
  end

  def versions
    @pages = Page.includes(:published_page)
                 .where(page_id: page_params[:page_id]).order(id: :desc)
    render layout: "admin"
  end

  def show_version
    @page = Page.includes(:user, :published_page).find(params.permit(:id)[:id])
    @versions = Page.where(page_id: @page.page_id).order(:id).ids
  end

  def new
    @page = Page.new(url: '/', content: "<h1>Title</h1>\n<p>Content here.</p>")
    render "editor"
  end

  def edit
    if !params[:vid].nil?
      @page = Page.find(params[:vid])
      current_page = CurrentPage.includes(:version).find_by(page_id: page_params[:page_id])
    else
      current_page = CurrentPage.includes(:version).find_by(page_id: page_params[:page_id])
      @page = current_page.version
    end
    render "editor"
  end

  private

  def page_params
    params.permit(:page_id, :url, :content)
  end

end

