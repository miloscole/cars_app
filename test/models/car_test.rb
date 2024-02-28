require "test_helper"

class CarTest < ActiveSupport::TestCase
  def setup
    @car = Car.new(
      brand: "Toyota",
      model: "Camry",
      production_year: "2024-01-01",
      price: 30000,
      user_id: 1,
    )
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

  test "full_name method should return brand + model" do
    assert_equal "Toyota Camry", @car.full_name
  end
end
