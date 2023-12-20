module CarsHelper
  def get_all_customers
    customers = [["Select a customer...", ""]]
    Customer.all.each do |customer|
      customers << [customer.full_name, customer.id]
    end
    customers
  end
end
