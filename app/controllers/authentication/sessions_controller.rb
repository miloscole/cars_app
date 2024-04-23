class Authentication::SessionsController < ApplicationController
  skip_before_action :protect_pages
  skip_before_action :set_current_user

  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    user = User.find_by(email: params[:login]) || User.find_by(username: params[:login])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      success_msg custom: "Successfully logged in"
      redirect_to root_path
    else
      error_msg_now
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    success_msg custom: "You have logged out successfully!"
    redirect_to new_session_path
  end
end
