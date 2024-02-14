class PasswordResetsController < ApplicationController
  skip_before_action :protect_pages

  def new
  end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      #send an email
      ResetPasswordMailer.with(user: @user).reset.deliver_later
    end
    redirect_to new_session_path, notice: "We sent an email if user with provided email address is found"
  end

  def edit
    @user = User.find_signed(params[:token], purpose: "password_reset")
    invalid_token unless @user
  end

  def update
    @user = User.find_signed(params[:token], purpose: "password_reset")
    return invalid_token unless @user

    if @user.update(passwords_params)
      redirect_to new_session_path, notice: "Password reset successfully! Log in with a new password."
    else
      render "edit", status: 422
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def invalid_token
    redirect_to new_session_path, alert: "Token is invalid or has expired. Please try again!"
  end
end
