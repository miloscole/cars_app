require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.new(
      first_name: "Ana",
      last_name: "Anic",
      email: "ana@ana.cc",
    )
  end

  test "should save valid customer" do
    assert @customer.save
  end

  test "should not save without first name" do
    @customer.first_name = ""

    assert_not @customer.save
  end

  test "should not save without last name" do
    @customer.last_name = ""

    assert_not @customer.save
  end

  test "should not save without email" do
    @customer.email = ""

    assert_not @customer.save
  end

  test "should not save with invalid email addresses" do
    invalid_addresses = %w[user@user,cc user.cc user.name@user. first@first@last.cc]
    invalid_addresses.each do |invalid_address|
      @customer.email = invalid_address

      assert_not @customer.save
    end
  end

  test "should save with valid email addresses" do
    valid_addresses = %w[user@user.cc USER@USER.CC US-ER@user.cc first.last@first.cc]
    valid_addresses.each do |valid_address|
      @customer.email = valid_address

      assert @customer.save
    end
  end

  test "email address should be unique" do
    duplicate_customer = @customer.dup
    @customer.save

    assert_not duplicate_customer.save
    assert_includes duplicate_customer.errors.full_messages, "Email has already been taken"
  end

  test "email addresses should be saved as lower-case" do
    email = "User@UsEr.Cc"
    @customer.email = email
    @customer.save

    assert_equal email.downcase, @customer.email
  end

  test "should not save with too short first name" do
    @customer.first_name = "M"

    assert_not @customer.save
  end

  test "should not save with too short last name" do
    @customer.last_name = "M"

    assert_not @customer.save
  end

  test "should not save with too long first name" do
    @customer.first_name = "M" * 26

    assert_not @customer.save
  end

  test "should not save with too long last name" do
    @customer.last_name = "M" * 26

    assert_not @customer.save
  end

  test "should return full_name as first_name + last_name" do
    assert_equal "Ana Anic", @customer.full_name
  end
end
