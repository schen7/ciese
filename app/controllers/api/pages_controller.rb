class Api::PagesController < ApplicationController
  
  def create
  end

  def show
    page = Page.includes(:user, :published_page).find(params[:id])
    versions = Page.where(page_id: page.page_id).order(:id).ids
    render json: page, meta: {versions: versions}
  end

  def update
  end

  def destroy
  end

end
