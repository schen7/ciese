class UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def deactivate
	@user = User.find(params[:id])
	@user.update_attribute(:active, false)
	redirect_to users_url
  end
  
  def activate
	@user = User.find(params[:id])
	@user.update_attribute(:active, true)
	redirect_to users_url
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  private
  
    def user_params
	  params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin, :staff, :active)
	end
end
