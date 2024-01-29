require "test_helper"

class EnginesControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
    @car = cars(:car2)
  end

  test "should render creating engine table inside new car form" do
    get new_car_path

    assert_response :success
    assert_select "form article h4", "Engine"
    assert_select "form table #car_engine_attributes_fuel_type"
  end

  test "allows to create a new engine with new car" do
    assert_difference("Engine.count", 1) do
      post cars_path, params: {
                        car: {
                          name: "Zastava",
                          model: "10",
                          production_year: Date.new,
                          price: 22,
                          engine_attributes: {
                            fuel_type: "benzine",
                            displacement: 1.6,
                            power: 60,
                            cylinders_num: 8,
                          },
                        },
                      }
    end

    assert_redirected_to cars_path
  end

  test "does not allow to create a new engine with new car" do
    post cars_path, params: {
                      car: {
                        name: "Dacia",
                        model: "Logan",
                        production_year: Date.new,
                        price: 2,
                        engine_attributes: {
                          fuel_type: "",
                          displacement: nil,
                          power: nil,
                          cylinders_num: nil,
                        },
                      },

                    }

    assert_response :unprocessable_entity
  end

  test "get edit car form with nested engine form" do
    get edit_car_path(@car)

    assert_response :success
    assert_select "form article h4", "Engine"
    assert_select "form table #car_engine_attributes_fuel_type"
  end

  test "allows to update a engine" do
    patch car_path(@car), params: {
                            car: {
                              engine_attributes: {
                                id: 2,
                                displacement: 1.2,
                              },
                            },
                          }

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car 2 was successfully updated!"
  end

  test "does not allow to update a engine" do
    patch car_path(@car), params: {
                            car: {
                              engine_attributes: {
                                id: 2,
                                fuel_type: nil,
                              },
                            },
                          }

    assert_response :unprocessable_entity
  end

  test "delete engine along with parent car" do
    assert_difference("Engine.count", -1) do
      delete car_path(@car)
    end

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car 2 was successfully deleted!"
  end
end
