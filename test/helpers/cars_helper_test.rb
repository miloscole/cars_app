class CarsHelperTest < ActionView::TestCase
  include CarsHelper

  def setup
    @customer1 = customers(:customer1)
    @customer2 = customers(:customer2)
  end

  test "should return all customers for dropdown" do
    customers_list = get_all_customers

    assert_equal customers_list.length, Customer.count + 1
    assert_equal customers_list[0], ["Select a customer...", ""]
    assert_equal customers_list[1], [@customer1.full_name, @customer1.id]
    assert_equal customers_list[2], [@customer2.full_name, @customer2.id]
  end
end
