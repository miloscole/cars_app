class CarsHelperTest < ActionView::TestCase
  include CarsHelper

  def setup
    Current.user = users(:user1)
  end

  test "get_all_customers should return customers for current user" do
    related_customers = Current.user.customers.map do |customer|
      [customer.full_name, customer.id]
    end
    expected_customers = related_customers.unshift(["Select a customer...", ""])

    assert_equal expected_customers, get_all_customers
  end
end
