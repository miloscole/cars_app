class Authentication::SessionsController < ApplicationController
  skip_before_action :protect_pages

  def new
  end

  def create
    user = User.find_by(email: params[:login]) || User.find_by(username: params[:login])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Successfully logged in"
    else
      flash[:alert] = "Invalid login!"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: "Successfully logged out"
  end
end
