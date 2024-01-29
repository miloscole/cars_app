require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
    @customer = customers(:customer1)
  end

  test "should render a list of customers" do
    get customers_path
    assert_response :success

    assert_select ".customer", 2
  end

  test "search a customer by query" do
    get customers_path(query: "Marko")

    assert_response :success
    assert_select ".customer", 1
  end

  test "should render show" do
    get customer_path(@customer)

    assert_response :success
    assert_select ".title", "Marko Markovic"
  end

  test "should render a new customer form" do
    get new_customer_path

    assert_response :success
    assert_select "h3", "New customer"
    assert_select "form"
  end

  test "allows to create a new customer" do
    post customers_path, params: {
                           customer: {
                             id: 3,
                             first_name: "Jim",
                             last_name: "Jimone",
                             email: "jim@mjim.cc",
                           },
                         }

    assert_redirected_to customers_path
    assert_equal flash[:notice], "Customer 3 was successfully created!"
  end

  test "does not allow to create a new customer with empty fields" do
    post customers_path, params: {
                           customer: {
                             first_name: "",
                             last_name: "",
                             email: "",
                           },
                         }

    assert_response :unprocessable_entity
  end

  test "render edit customer form" do
    get edit_customer_path(@customer)

    assert_response :success
    assert_select "h3", "Editing customer"
    assert_select "form"
  end

  test "allows to update a customer" do
    patch customer_path(@customer), params: {
                                      customer: {
                                        last_name: "Micic",
                                      },
                                    }

    assert_redirected_to customers_path
    assert_equal flash[:notice], "Customer 1 was successfully updated!"
  end

  test "does not allow to update a customer with an invalid field" do
    patch customer_path(@customer), params: {
                                      customer: {
                                        last_name: "",
                                      },
                                    }

    assert_response :unprocessable_entity
  end

  test "render delete customer form" do
    get delete_customer_path(@customer)

    assert_response :success
    assert_select "h2", "Confirm your action!"
    assert_select "form"
  end

  test "can delete customers" do
    assert_difference("Customer.count", -1) do
      delete customer_path(@customer)
    end

    assert_redirected_to customers_path
    assert_equal flash[:notice], "Customer 1 was successfully deleted!"
  end
end
