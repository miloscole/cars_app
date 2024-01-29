require "test_helper"

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
  end

  test "should get welcome as root path" do
    get root_path

    assert_response :success
    assert_select "h2", 'Welcome to the "Cars application"'
  end
end
