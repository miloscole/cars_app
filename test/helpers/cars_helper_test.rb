class CarsHelperTest < ActionView::TestCase
  include CarsHelper
  include Shared::IndexHelper
  include ApplicationHelper

  def setup
    Current.user = users(:user1)
    @cars = Car.where(user_id: Current.user.id)
  end

  test "all_customers_for_car should return customers for current user" do
    related_customers = Current.user.customers.map do |customer|
      [customer.full_name, customer.id]
    end
    expected_customers = related_customers.unshift(["Select a customer...", ""])

    assert_equal expected_customers, all_customers_for_car
  end

  test "load_cars should load cars with specified fields" do
    loaded_cars = load_cars

    assert_equal loaded_cars.first.attributes.length, FIELDS_FOR_LOAD.length

    loaded_cars.each do |car|
      assert_includes car.attributes.keys, "id"
      assert_includes car.attributes.keys, "brand"
      assert_includes car.attributes.keys, "model"
      assert_includes car.attributes.keys, "production_year"
      assert_includes car.attributes.keys, "price"
      assert_includes car.attributes.keys, "customer"
    end
  end

  test "search_cars should filter objects based on query" do
    query = @cars.first.brand

    filtered_cars = search_cars(query)

    filtered_cars.each do |car|
      assert_includes car.brand.downcase, query.downcase
    end
  end

  test "load_car_for_show should load car details for show" do
    car = @cars.second
    loaded_car_attributes = load_car_for_show(car.id).attributes

    assert_equal car.brand, loaded_car_attributes["brand"]
    assert_equal car.model, loaded_car_attributes["model"]
    assert_equal car.production_year, loaded_car_attributes["production_year"]
    assert_equal car.price, loaded_car_attributes["price"]
    assert_equal car.customer.full_name, loaded_car_attributes["customer"]
  end
end
