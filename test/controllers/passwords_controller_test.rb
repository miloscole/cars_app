require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login

    @user_params = { user: { password: "newpassword", password_confirmation: "newpassword" } }
  end

  test "should render edit password form" do
    get password_path

    assert_response :success
    assert_select "h3", "Change your password"
    assert_select "form"
  end

  test "should update password" do
    patch password_path, params: @user_params

    assert_redirected_to root_path
    assert_equal "Password  was successfully updated!", flash[:success]
  end

  test "should not update password with short password" do
    @user_params[:user][:password] = "short"
    @user_params[:user][:password_confirmation] = "short"
    patch password_path, params: @user_params

    assert_response :unprocessable_entity
    assert_select "small", "Password is too short (minimum is 6 characters)"
  end

  test "should not update password with different confirmation password" do
    @user_params[:user][:password_confirmation] = "oldpassword"
    patch password_path, params: @user_params

    assert_response :unprocessable_entity
    assert_select "small", "Password confirmation doesn't match Password"
  end
end
