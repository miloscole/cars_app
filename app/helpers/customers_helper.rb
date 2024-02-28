module CustomersHelper
  include ActionView::Helpers::TagHelper

  FIELDS_FOR_LOAD = [
    "customers.id",
    "CONCAT(customers.first_name, ' ', customers.last_name) AS name",
    "customers.email",
    "customers.phone",
    "customers.notes",
  ]

  SEARCHABLE_FIELDS = [:first_name, :last_name, :email]

  def load_customers
    load_index_objects(Customer, FIELDS_FOR_LOAD)
  end

  def search_customers(query)
    customers = load_customers
    search_objects(customers, SEARCHABLE_FIELDS, Customer, query)
  end

  def customer_dropdown_option(cus)
    content_tag(:option, cus.full_name, value: cus.id)
  end
end
