require "test_helper"

class CustomersHelperTest < ActionView::TestCase
  include CustomersHelper
  include Shared::IndexHelper

  def setup
    @customer = customers(:customer1)
  end

  test "customer_dropdown_option should return expected option tag" do
    expected_option_tag = content_tag(:option, @customer.full_name, value: @customer.id)

    assert_equal expected_option_tag, customer_dropdown_option(@customer)
  end
end
