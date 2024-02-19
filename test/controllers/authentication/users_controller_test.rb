require "test_helper"

class Authentication::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user_params = {
      user: {
        email: "test@test.cc",
        username: "testuser",
        password: "password",
      },
    }
  end

  test "should get new (register)" do
    get new_user_path

    assert_response :success
    assert_select "h3", "Create your CarsApp account"
    assert_select "form"
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_path, params: @user_params
    end
    assert_redirected_to root_path
    assert_includes flash[:notice], "User"
    assert_includes flash[:notice], "was successfully created!"
  end

  test "should redirect to new when user params are invalid" do
    @user_params[:user][:email] = ""
    post users_path, params: @user_params

    assert_response :unprocessable_entity
  end

  test "should set session[:user_id] after user creation" do
    post users_path, params: @user_params

    assert session[:user_id]
  end
end
