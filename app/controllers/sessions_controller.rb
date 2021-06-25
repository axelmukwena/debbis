class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:notice] = 'Logged in successfully'
      redirect_back_or members_path
    else
      flash[:error] = 'Invalid username or password'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:notice] = 'Logged out successfully'
    redirect_to root_url
  end
end