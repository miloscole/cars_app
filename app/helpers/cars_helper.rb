module CarsHelper
  CONCAT_CUS_NAME = "CONCAT(customers.first_name, ' ', customers.last_name) AS customer"

  FIELDS_FOR_LOAD = [
    "cars.id",
    "cars.brand",
    "cars.model",
    "cars.production_year",
    "cars.price",
    CONCAT_CUS_NAME,
  ]

  SEARCHABLE_FIELDS = [:brand, :model]

  def all_customers_for_car
    load_customers = Customer.where(user_id: Current.user.id).select("id", "first_name", "last_name")

    load_customers.map do |customer|
      [customer.full_name, customer.id]
    end
      .unshift(["Select a customer...", ""])
  end

  def load_cars
    load_index_objects(Car, FIELDS_FOR_LOAD) { |q| q.left_joins(:customer) }
  end

  def search_cars
    cars = load_cars
    search_objects(cars, SEARCHABLE_FIELDS, Car)
  end

  def load_car_for_show
    Car.select(
      "user_id", "brand", "model", "production_year", "price", CONCAT_CUS_NAME
    )
      .left_joins(:customer).find_by(id: params[:id])
  end
end
