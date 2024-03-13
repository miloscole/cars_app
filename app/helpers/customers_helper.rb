module CustomersHelper
  include ActionView::Helpers::TagHelper

  def customer_dropdown_option(cus)
    content_tag(:option, cus.full_name, value: cus.id, selected: "selected")
  end
end
