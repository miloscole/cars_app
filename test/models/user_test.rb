require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      username: "user11",
      email: "user11@user.cc",
      password: "password",
      password_confirmation: "password",
    )
  end

  test "should create a valid user" do
    assert @user.save
  end

  test "should not create a user without username" do
    @user.username = ""

    assert_not @user.save
  end

  test "should not create a user without email" do
    @user.email = ""

    assert_not @user.save
  end

  test "should not create a user without password" do
    @user.password = @user.password_confirmation = ""

    assert_not @user.save
  end

  test "should not create a user with too short username" do
    @user.username = "Mm"

    assert_not @user.save
  end

  test "should not create a user with too long username" do
    @user.username = "M" * 16

    assert_not @user.save
  end

  test "username should contain alphanumeric characters" do
    @user.username = "user!@#"

    assert_not @user.save
  end

  test "username should be saved in lower case" do
    username = "UserUsEr11"
    @user.username = username
    @user.save

    assert_equal username.downcase, @user.username
  end

  test "should not create a user with invalid email addresses" do
    invalid_addresses = %w[user@user,cc user.cc user.name@user. first@first@last.cc]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address

      assert_not @user.save
    end
  end

  test "should create a user with valid email addresses" do
    valid_addresses = %w[user@user.cc USER@USER.CC US-ER@user.cc first.last@first.cc]
    valid_addresses.each do |valid_address|
      @user.email = valid_address

      assert @user.save
    end
  end

  test "email should be saved in lower case" do
    email = "User@UsEr.Cc"
    @user.email = email
    @user.save

    assert_equal email.downcase, @user.email
  end

  test "email address and username should be unique" do
    duplicate_user = @user.dup
    @user.save

    assert_not duplicate_user.save
    assert_includes duplicate_user.errors.full_messages, "Email has already been taken"
    assert_includes duplicate_user.errors.full_messages, "Username has already been taken"
  end

  test "password should be at least 6 characters long" do
    @user.password = @user.password_confirmation = "M" * 5

    assert_not @user.save
  end
end
