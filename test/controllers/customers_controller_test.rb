require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  def setup
    login

    @customer = customers(:customer1)
    @customer_params = {
      customer: {
        first_name: @customer.first_name,
        last_name: @customer.last_name,
        email: @customer.email + "c",
        user_id: 1,
      },
    }
  end

  test "should render a list of customers created by current user" do
    get customers_path

    assert_response :success
    assert_select ".customer", 2
  end

  test "should search a customer by query" do
    get customers_path(query: "#{@customer.first_name}")

    assert_response :success
    assert_select ".customer", 1
  end

  test "should render show" do
    get customer_path(@customer)

    assert_response :success
    assert_select ".title", "#{@customer.full_name}"
  end

  test "should render a new customer form" do
    get new_customer_path

    assert_response :success
    assert_select "h3", "New customer"
    assert_select "form"
  end

  test "should allow to create a new customer" do
    post customers_path, params: @customer_params

    assert_redirected_to customers_path
    assert_equal flash[:notice], "Customer #{@customer.full_name} was successfully created!"
  end

  test "should not allow to create a new customer with empty fields" do
    @customer_params[:customer][:first_name] = ""
    @customer_params[:customer][:last_name] = ""
    @customer_params[:customer][:email] = ""
    post customers_path, params: @customer_params

    assert_response :unprocessable_entity
  end

  test "should render edit customer form" do
    get edit_customer_path(@customer)

    assert_response :success
    assert_select "h3", "Editing customer"
    assert_select "form"
  end

  test "should allow to update a customer" do
    last_name = "Micic"
    @customer_params[:customer][:last_name] = last_name
    patch customer_path(@customer), params: @customer_params

    assert_redirected_to customers_path
    assert_equal flash[:notice],
                 "Customer #{@customer.first_name} #{last_name} was successfully updated!"
  end

  test "should not allow to update a customer with an invalid field" do
    @customer_params[:customer][:last_name] = ""
    patch customer_path(@customer), params: @customer_params

    assert_response :unprocessable_entity
  end

  test "should render delete customer form" do
    get delete_customer_path(@customer)

    assert_response :success
    assert_select "h2", "Confirm your action!"
    assert_select "form"
  end

  test "should delete customer" do
    assert_difference("Customer.count", -1) do
      delete customer_path(@customer)
    end
    assert_redirected_to customers_path
    assert_equal flash[:notice], "Customer #{@customer.full_name} was successfully deleted!"
  end
end
