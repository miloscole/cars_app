require "test_helper"

class EnginesControllerTest < ActionDispatch::IntegrationTest
  def setup
    login

    @car = cars(:car2)
    @engine = engines(:engine2)
    @car_params = {
      car: {
        name: @car.name,
        model: @car.model,
        production_year: @car.production_year,
        price: @car.price,
        engine_attributes: {
          fuel_type: @engine.fuel_type,
          displacement: @engine.displacement,
          power: @engine.power,
          cylinders_num: @engine.cylinders_num,
        },
      },
    }
  end

  test "should render creating engine table inside a new car form" do
    get new_car_path

    assert_response :success
    assert_select "form article h4", "Engine"
    assert_select "form table #car_engine_attributes_fuel_type"
  end

  test "should allow to create a new engine with a new car" do
    assert_difference("Engine.count", 1) do
      post cars_path, params: @car_params
    end
    assert_redirected_to cars_path
  end

  test "should not allow to create a new engine with empty fileds" do
    @car_params[:car][:engine_attributes][:fuel_type] = ""
    @car_params[:car][:engine_attributes][:power] = nil
    post cars_path, params: @car_params

    assert_response :unprocessable_entity
  end

  test "should get edit car form with nested engine form" do
    get edit_car_path(@car)

    assert_response :success
    assert_select "form article h4", "Engine"
    assert_select "form table #car_engine_attributes_fuel_type"
  end

  test "should allow to update an engine" do
    @car_params[:car][:engine_attributes][:power] = 150
    patch car_path(@car), params: @car_params

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car #{@car.full_name} was successfully updated!"
  end

  test "should not allow to update an engine" do
    @car_params[:car][:engine_attributes][:fuel_type] = nil
    patch car_path(@car), params: @car_params

    assert_response :unprocessable_entity
  end

  test "should delete engine along with parent car" do
    assert_difference("Engine.count", -1) do
      delete car_path(@car)
    end
    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car #{@car.full_name} was successfully deleted!"
  end
end
