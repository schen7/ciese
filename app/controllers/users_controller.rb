class UsersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :get_user, except: [:index]
  
  def index
    @users = User.all
  end
  
  def deactivate
    @user.update_attribute(:active, false)
    redirect_to users_url
  end
  
  def activate
    @user.update_attribute(:active, true)
    redirect_to users_url
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      log_in(@user)
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation, :admin, :staff, :active)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
