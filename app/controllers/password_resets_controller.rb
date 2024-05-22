class PasswordResetsController < ApplicationController
  skip_before_action :protect_pages
  skip_before_action :set_current_user

  def new
    redirect_to root_path if session[:user_id]
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      #send an email
      ResetPasswordMailer.with(user: @user).reset.deliver_later
    end
    success_msg custom: "We sent an email if user with provided email address is found"
    redirect_to new_session_path
  end

  def edit
    @user = User.find_signed(params[:token], purpose: "password_reset")
    invalid_token unless @user
  end

  def update
    @user = User.find_signed(params[:token], purpose: "password_reset")
    return invalid_token unless @user

    if @user.update(passwords_params)
      success_msg custom: "Password reset successfully! Log in with a new password."
      redirect_to new_session_path
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def invalid_token
    error_msg "Token is invalid or has expired. Please try again!"
    redirect_to new_session_path
  end
end
