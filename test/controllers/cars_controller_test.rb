require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login

    @car = cars(:car1)
    @car_params = {
      car: {
        name: @car.name,
        model: @car.model,
        production_year: @car.production_year,
        price: @car.price,
      },
    }
  end

  test "should render a list of cars created by current user" do
    get cars_path

    assert_response :success
    assert_select ".car", 3
  end

  test "should search a car by query" do
    get cars_path(query: "#{@car.name}")

    assert_response :success
    assert_select ".car", 1
  end

  test "should render show" do
    get car_path(@car)

    assert_response :success
    assert_select ".title", "#{@car.name}"
  end

  test "should render a new car form" do
    get new_car_path

    assert_response :success
    assert_select "h3", "New car"
    assert_select "form"
  end

  test "should allow to create a new car" do
    post cars_path, params: @car_params

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car #{@car.full_name} was successfully created!"
  end

  test "should not allow to create a new car with empty fields" do
    @car_params[:car][:name] = ""
    @car_params[:car][:model] = ""
    post cars_path, params: @car_params

    assert_response :unprocessable_entity
  end

  test "should render edit car form" do
    get edit_car_path(@car)

    assert_response :success
    assert_select "h3", "Editing car"
    assert_select "form"
  end

  test "should allow to update a car" do
    model = "Demio"
    @car_params[:car][:model] = model
    patch car_path(@car), params: @car_params

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car #{@car.name} #{model} was successfully updated!"
  end

  test "should not allow to update a car with an invalid field" do
    @car_params[:car][:model] = ""
    patch car_path(@car), params: @car_params

    assert_response :unprocessable_entity
  end

  test "should render delete car form" do
    get delete_car_path(@car)

    assert_response :success
    assert_select "h2", "Confirm your action!"
    assert_select "form"
  end

  test "should delete a car" do
    assert_difference("Car.count", -1) do
      delete car_path(@car)
    end
    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car #{@car.full_name} was successfully deleted!"
  end
end
