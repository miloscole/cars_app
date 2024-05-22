require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @user_params = { user: { password: "password", password_confirmation: "password" } }
    @token = @user.signed_id(purpose: "password_reset")
  end

  test "should render a new password reset form" do
    @user = users(:user1)
    @user_params = { user: { password: "password", password_confirmation: "password" } }
    get password_reset_path

    assert_response :success
    assert_select "h3", "Give us your email address!"
    assert_select "form"
  end

  test "should create password reset and redirect to new session path" do
    assert_enqueued_emails 1 do
      post password_reset_path, params: { email: @user.email }
    end
    assert_redirected_to new_session_path
    assert_equal "We sent an email if user with provided email address is found", flash[:success]
  end

  test "should not create password reset with non-existing email" do
    assert_enqueued_emails 0 do
      post password_reset_path, params: { email: "wrong@email.cc" }
    end
    assert_redirected_to new_session_path
    assert_equal "We sent an email if user with provided email address is found", flash[:success]
  end

  test "should render edit form" do
    token = @user.signed_id(purpose: "password_reset")
    get password_reset_edit_path(token: @token)

    assert_response :success
    assert_select "h3", "Update your password"
    assert_select "form"
  end

  test "should not render edit form with invalid token" do
    invalid_token = "invalid_token"
    get password_reset_edit_path(token: invalid_token)

    assert_redirected_to new_session_path
    assert_equal "Token is invalid or has expired. Please try again!", flash[:error]
  end

  test "should update password and redirect to new session path" do
    patch password_reset_edit_path(token: @token), params: @user_params

    assert_redirected_to new_session_path
    assert_equal "Password reset successfully! Log in with a new password.", flash[:success]
  end

  test "update should fail with invalid params" do
    @user_params[:user][:password_confirmation] = "wrongpassword"
    patch password_reset_edit_path(token: @token), params: @user_params

    assert_response :unprocessable_entity
    assert_select "small", "Password confirmation doesn't match Password"
  end

  test "should handle invalid token on update" do
    invalid_token = "invalid_token"
    patch password_reset_edit_path(token: invalid_token), params: @user_params

    assert_redirected_to new_session_path
    assert_equal "Token is invalid or has expired. Please try again!", flash[:error]
  end
end
