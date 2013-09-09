class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :activate, :deactivate]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:activate, :deactivate]
  
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
  
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_path, notice: "Please log in."
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    raise User::NotAuthorized unless current_user?(@user)
  end
  
  def admin_user
    is_admin?
  end
end
