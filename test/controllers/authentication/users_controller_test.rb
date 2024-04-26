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
    stub_request(
      :get, "http://ip-api.com/json/127.0.0.1"
    ).to_return(status: 200, body: { status: "fail" }.to_json)

    assert_difference("User.count", 1) do
      post users_path, params: @user_params
    end
    assert_redirected_to root_path
    assert_includes flash[:success], "Account"
    assert_includes flash[:success], "was successfully created!"
  end

  test "should respond with unprocessable_entity when user params are invalid" do
    stub_request(
      :get, "http://ip-api.com/json/127.0.0.1"
    ).to_return(status: 200, body: { status: "fail" }.to_json)
    @user_params[:user][:email] = ""
    post users_path, params: @user_params

    assert_response :unprocessable_entity
  end

  test "should set session[:user_id] after user creation" do
    stub_request(
      :get, "http://ip-api.com/json/127.0.0.1"
    ).to_return(status: 200, body: { status: "fail" }.to_json)
    post users_path, params: @user_params

    assert session[:user_id]
  end
end
