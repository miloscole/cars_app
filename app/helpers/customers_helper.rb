module CustomersHelper
  include ActionView::Helpers::TagHelper

  def customer_visible_attributes(object)
    customer_hash = {}
    customer_hash["name"] = object.full_name
    customer_hash.merge(visible_attributes(object, ["first_name", "last_name"]))
  end

  def customer_dropdown_option(cus)
    content_tag(:option, cus.full_name, value: cus.id)
  end
end
