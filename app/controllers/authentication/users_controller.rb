class Authentication::UsersController < ApplicationController
  include NoticeHelper

  skip_before_action :protect_pages
  skip_before_action :set_current_user

  def new
    return redirect_to root_path if session[:user_id]
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: notice_msg(@user, @user.username, :created)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password)
  end
end
