require "test_helper"

class EngineTest < ActiveSupport::TestCase
  def setup
    @car = cars(:car3)
    @engine = Engine.new(
      fuel_type: "gasoline",
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
end
