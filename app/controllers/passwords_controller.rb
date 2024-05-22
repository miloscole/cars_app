class PasswordsController < ApplicationController
  def edit
  end

  def update
    if Current.user.update(passwords_params)
      success_msg for: :password
      redirect_to root_path
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
