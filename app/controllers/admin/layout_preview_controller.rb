class Admin::LayoutPreviewController < ApplicationController

  before_action :require_login
  before_action :require_staff_or_admin

  def show
    @layout = params[:layout]
    render layout: @layout
  end

end


