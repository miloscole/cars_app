require "test_helper"

class CarTest < ActiveSupport::TestCase
  def setup
    Current.user = users(:user1)
    @car = Car.new(
      brand: "Toyota",
      model: "Camry",
      production_year: "2024-01-01",
      price: 30000,
      user_id: Current.user.id,
      customer: nil,
    )
    @params_page = "1"
  end

  test "should save valid car" do
    assert @car.save
  end

  test "should not save car without brand" do
    @car.brand = ""

    assert_not @car.save
  end

  test "should not save car without model" do
    @car.model = ""

    assert_not @car.save
  end

  test "should not save car without production year" do
    @car.production_year = ""

    assert_not @car.save
  end

  test "should not save car without price" do
    @car.price = nil

    assert_not @car.save
  end

  test "should not save car with invalid customer" do
    customer = customers(:customer3)
    @car.customer = customer
    assert_not @car.save
  end

  test "should save car with valid customer" do
    customer = customers(:customer1)
    @car.customer = customer
    assert @car.save
  end

  test "full_name method should return brand + model" do
    assert_equal "Toyota Camry", @car.full_name
  end

  test "load_for_show method should return correct car" do
    car = cars(:car1)
    loaded_car_attributes = Car.load_for_show(car.id).attributes

    assert_equal car.brand, loaded_car_attributes["brand"]
    assert_equal car.model, loaded_car_attributes["model"]
    assert_equal car.production_year, loaded_car_attributes["production_year"]
    assert_equal car.price, loaded_car_attributes["price"]
  end

  test "load_all should load cars with specified fields" do
    loaded_cars = Car.load_all(@params_page)

    assert_equal loaded_cars.length, Car.where(user_id: Current.user.id).count
    assert_equal loaded_cars.first.attributes.length, Car::FIELDS_TO_LOAD.length

    loaded_cars.each do |car|
      assert_includes car.attributes.keys, "id"
      assert_includes car.attributes.keys, "brand"
      assert_includes car.attributes.keys, "model"
      assert_includes car.attributes.keys, "production_year"
      assert_includes car.attributes.keys, "price"
      assert_includes car.attributes.keys, "customer"
    end
  end

  test "search method should filter cars based on query" do
    query = cars(:car1).brand

    filtered_cars = Car.search(query, @params_page)

    filtered_cars.each do |car|
      assert_includes car.brand.downcase, query.downcase
    end
  end

  test "load_customers method should return nested array" do
    expected_customers = Current.user.customers.map do |customer|
      [customer.full_name, customer.id]
    end
    assert_equal expected_customers, Car.load_customers
  end
end
