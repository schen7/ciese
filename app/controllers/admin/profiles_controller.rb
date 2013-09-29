class Admin::ProfilesController < ApplicationController

  before_action :require_login
  before_action :require_staff_or_admin

  def index
  end

end
