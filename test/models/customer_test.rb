require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  def setup
    Current.user = users(:user1)
    @customer = Customer.new(
      first_name: "Ana",
      last_name: "Anic",
      email: "ana@ana.cc",
      user_id: Current.user.id,
    )
    @params_page = "1"
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

  test "full_name method should return first_name + last_name" do
    assert_equal "Ana Anic", @customer.full_name
  end

  test "load_all method should load customers with specified fields" do
    loaded_customers = Customer.load_all(@params_page)

    assert_equal loaded_customers.length, Customer.where(user_id: Current.user.id).count
    assert_equal loaded_customers.first.attributes.length, Customer::FIELDS_TO_LOAD.length

    loaded_customers.each do |customer|
      assert_includes customer.attributes.keys, "id"
      assert_includes customer.attributes.keys, "name"
      assert_includes customer.attributes.keys, "email"
      assert_includes customer.attributes.keys, "phone"
      assert_includes customer.attributes.keys, "notes"
    end
  end

  test "search method should filter customers based on query" do
    query = customers(:customer1).email

    filtered_customers = Customer.search(query, @page)

    filtered_customers.each do |customer|
      assert_includes customer.email.downcase, query.downcase
    end
  end
end
