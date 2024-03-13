class CustomersHelperTest < ActionView::TestCase
  include CustomersHelper

  def setup
    Current.user = users(:user1)
    @customer = customers(:customer1)
  end

  test "customer_dropdown_option should return expected option tag" do
    expected_option_tag = content_tag(
      :option,
      @customer.full_name,
      value: @customer.id,
      selected: "selected",
    )

    assert_equal expected_option_tag, customer_dropdown_option(@customer)
  end
end
