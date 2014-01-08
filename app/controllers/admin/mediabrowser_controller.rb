class Admin::MediabrowserController < ApplicationController

  before_action :require_login
  before_action :require_staff_or_admin

  def index
    render layout: "admin"
  end

end
