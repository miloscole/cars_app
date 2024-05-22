require "test_helper"

class Authentication::SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user1)
    @user_params = { login: @user.email, password: "testme" }
  end

  test "should get new (login)" do
    get new_session_path

    assert_response :success
    assert_select "h3", "Log in to CarsApp"
    assert_select "form"
  end

  test "should create session with valid credentials" do
    post sessions_path, params: @user_params

    assert_equal session[:user_id], @user.id
    assert_redirected_to root_path
  end

  test "should redirect to new session path with invalid password" do
    @user_params[:password] = "pas"
    post sessions_path, params: @user_params

    assert_response :unprocessable_entity
    assert_equal "Something went wrong, please try again", flash[:error]
  end

  test "should redirect to new session path with invalid login (username/email)" do
    @user_params[:login] = "U"
    post sessions_path, params: @user_params

    assert_response :unprocessable_entity
    assert_equal "Something went wrong, please try again", flash[:error]
  end

  test "should destroy session" do
    login
    assert session[:user_id]
    delete session_path(@user)

    assert_nil session[:user_id]
    assert_redirected_to new_session_path
  end
end
