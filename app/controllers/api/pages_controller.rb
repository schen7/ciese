class Api::PagesController < ApplicationController
  
  # before_action :require_login
  # before_action :require_staff_or_admin

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

  def show
    page = Page.includes(:user, :published_page).find(params[:id])
    versions = Page.where(page_id: page.page_id).order(:id).ids
    render json: page, meta: {versions: versions}
  end

  def update
    page = Page.find(params.permit(:id)[:id])
    published_page = PublishedPage.find_by(page_id: page.page_id)
    if published_page.nil?
      published_page = PublishedPage.new(version_id: page.id, page_id: page.page_id)
    else
      published_page.version_id = page.id
    end
    if published_page.save
      render json: {published: true}
    else
      render json: {published: false, errors: published_page.errors.full_messages}
    end
  end

  def destroy
    page = Page.find(params.permit(:id)[:id])
    PublishedPage.where(page_id: page.page_id).destroy_all
    render json: {unpublished: true}
  end

  private

  def page_params
    params.permit(:page_id, :url, :content)
  end

  def publish_params
    params.permit(:version_id, :page_id)
  end

end
