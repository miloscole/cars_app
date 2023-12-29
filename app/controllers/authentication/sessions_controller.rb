class Authentication::SessionsController < ApplicationController
  skip_before_action :protect_pages

  def new
  end

  def create
    @user = User.find_by(email: params[:login]) || User.find_by(username: params[:login])

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to new_session_path, alert: "Invalid login!"
    end
  end

  def destroy
    session.delete(:user_id)

    redirect_to new_session_path
  end
end
