class Authentication::UsersController < ApplicationController
  skip_before_action :protect_pages
  skip_before_action :set_current_user

  def new
    return redirect_to root_path if session[:user_id]
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      FetchCountryJob.perform_later(@user.id, request.remote_ip)
      session[:user_id] = @user.id
      success_msg for: :account
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
