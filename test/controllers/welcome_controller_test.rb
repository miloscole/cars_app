require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
  end

  test "should get index" do
    get root_path

    assert_select "h2", 'Welcome to the "Cars application"'
    assert_response :success
  end
end
