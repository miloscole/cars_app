module CustomersHelper
  include ApplicationHelper

  def customer_visible_attributes(object)
    customer_hash = {}
    customer_hash["name"] = object.full_name
    customer_hash.merge(visible_attributes(object, ["first_name", "last_name"]))
  end
end
