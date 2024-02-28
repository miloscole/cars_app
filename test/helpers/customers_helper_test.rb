require "test_helper"

class CustomersHelperTest < ActionView::TestCase
  include CustomersHelper
  include Shared::IndexHelper
  include ApplicationHelper

  def setup
    Current.user = users(:user1)
    @customer = customers(:customer1)
  end

  test "customer_dropdown_option should return expected option tag" do
    expected_option_tag = content_tag(:option, @customer.full_name, value: @customer.id)

    assert_equal expected_option_tag, customer_dropdown_option(@customer)
  end

  test "load_customers should load customers with specified fields" do
    loaded_customers = load_customers

    assert_equal loaded_customers.first.attributes.length, FIELDS_FOR_LOAD.length

    loaded_customers.each do |customer|
      assert_includes customer.attributes.keys, "id"
      assert_includes customer.attributes.keys, "name"
      assert_includes customer.attributes.keys, "email"
      assert_includes customer.attributes.keys, "phone"
      assert_includes customer.attributes.keys, "notes"
    end
  end

  test "search_customers should filter objects based on query" do
    query = @customer.email

    filtered_customers = search_customers(query)

    filtered_customers.each do |customer|
      assert_includes customer.email.downcase, query.downcase
    end
  end
end
