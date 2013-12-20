class Admin::PagesController < ApplicationController
  
  before_action :require_login
  before_action :require_staff_or_admin

  def index
    @pages = CurrentPage.with_publish_info.joins(:version).includes(version: [:user]).order("pages.url ASC")
  end

  def versions
    @pages = Page.includes(:published_page)
                 .where(page_id: page_params[:page_id]).order(id: :desc)
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

  def create
    data = page_params.merge(user: current_user, page_id: page_params[:page_id])
    page = Page.new(data)
    if page.save
      CurrentPage.where(page_id: page.page_id).destroy_all
      page.create_current_page(page_id: page.page_id)
      render json: {saved: true, version_id: page.id, page_id: page.page_id}
    else
      render json: {saved: false, errors: page.errors.full_messages}
    end
  end

  def editor_publish
    page = PublishedPage.find_by(page_id: publish_params[:page_id])
    if page.nil?
      page = PublishedPage.new(publish_params)
    else
      page.version_id = publish_params[:version_id]
    end
    if page.save
      render json: {published: true}
    else
      render json: {published: false, errors: page.errors.full_messages}
    end
  end

  private

  def page_params
    params.permit(:page_id, :url, :content)
  end

  def publish_params
    params.permit(:version_id, :page_id)
  end

  def publish_page
    PublishedPage.where(page_id: publish_params[:page_id]).destroy_all
  end

end

