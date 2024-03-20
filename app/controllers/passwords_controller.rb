class PasswordsController < ApplicationController
  def edit
  end

  def update
    if Current.user.update(passwords_params)
      redirect_to root_path, notice: "Successfully updated password"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
