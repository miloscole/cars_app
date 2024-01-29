require "test_helper"

class CarsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
    @car = cars(:car1)
  end

  test "should render a list of cars" do
    get cars_path
    assert_response :success

    assert_select ".car", 2
  end

  test "search a car by query" do
    get cars_path(query: "Mazda")

    assert_response :success
    assert_select ".car", 1
  end

  test "should render show" do
    get car_path(@car)

    assert_response :success
    assert_select ".title", "Mazda"
  end

  test "should render a new car form" do
    get new_car_path

    assert_response :success
    assert_select "h3", "New car"
    assert_select "form"
  end

  test "allows to create a new car" do
    post cars_path, params: {
                      car: {
                        name: "Lada",
                        model: "Vesta",
                        production_year: Date.new,
                        price: 222,
                      },
                    }

    assert_redirected_to cars_path
    assert flash[:notice].include?("Car") && flash[:notice].include?("was successfully created")
  end

  test "does not allow to create a new car with empty fields" do
    post cars_path, params: {
                      car: {
                        name: "",
                        model: "",
                      },
                    }

    assert_response :unprocessable_entity
  end

  test "render edit car form" do
    get edit_car_path(@car)

    assert_response :success
    assert_select "h3", "Editing car"
    assert_select "form"
  end

  test "allows to update a car" do
    patch car_path(@car), params: {
                            car: {
                              model: "Demio",
                            },
                          }

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car 1 was successfully updated!"
  end

  test "does not allow to update a car with an invalid field" do
    patch car_path(@car), params: {
                            car: {
                              model: "",
                            },
                          }

    assert_response :unprocessable_entity
  end

  test "render delete car form" do
    get delete_car_path(@car)

    assert_response :success
    assert_select "h2", "Confirm your action!"
    assert_select "form"
  end

  test "can delete cars" do
    assert_difference("Car.count", -1) do
      delete car_path(@car)
    end

    assert_redirected_to cars_path
    assert_equal flash[:notice], "Car 1 was successfully deleted!"
  end
end
