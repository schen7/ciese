class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(params.permit(:username))
    if user && user.authenticate(params.permit(:password)[:password])
      log_in(user)
      redirect_back_or(root_path)
    else
      flash.now[:error] = "Your username/password combination is not correct."
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
