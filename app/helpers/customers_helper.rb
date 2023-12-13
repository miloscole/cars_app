module CustomersHelper
  def customer_visible_attributes(object)
    customer_hash = {}
    customer_hash["name"] = object.full_name
    customer_hash.merge(visible_attributes(object, ["first_name", "last_name"]))
  end

  def render_text_field_or_area(f, key)
    options = { placeholder: key.titleize, class: "margin-reset" }

    if key == "notes"
      f.text_area(key, options.merge(rows: 4))
    else
      f.text_field(key, options)
    end
  end
end
