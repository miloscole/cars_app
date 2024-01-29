require "test_helper"

class EngineTest < ActiveSupport::TestCase
  def setup
    @car = cars(:car3)
    @engine = Engine.new(
      fuel_type: "benzine",
      displacement: 1.6,
      power: 100,
      cylinders_num: 8,
      car: @car,
    )
  end

  test "should save valid engine" do
    assert @engine.save
  end

  test "should not save without fuel_type" do
    @engine.fuel_type = ""

    assert_not @engine.save
  end

  test "should not save without displacement" do
    @engine.displacement = nil

    assert_not @engine.save
  end

  test "should not save without power" do
    @engine.power = nil

    assert_not @engine.save
  end

  test "should not save without cylinders number" do
    @engine.cylinders_num = nil

    assert_not @engine.save
  end

  test "engine should belong to a car" do
    assert_equal @car, @engine.car
  end

  test "should return enum keys" do
    assert_equal ["benzine", "diesel"], Engine.enum_keys("fuel_type")
    assert_equal ["1.2", "1.4", "1.6", "1.8"], Engine.enum_keys("displacement")
    assert_equal ["8", "16"], Engine.enum_keys("cylinders_num")
    assert_equal ["60", "100", "150", "200"], Engine.enum_keys("power")
  end
end
