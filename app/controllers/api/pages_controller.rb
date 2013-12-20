class Api::PagesController < ApplicationController
  
  def create
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

  def publish_params
    params.permit(:version_id, :page_id)
  end

end
