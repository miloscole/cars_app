module CustomersHelper
  def customer_visible_attributes(object)
    customer_hash = {}
    customer_hash["name"] = object.full_name
    customer_hash.merge(visible_attributes(object, ["first_name", "last_name"]))
  end

  def render_form_field(f, key, options = {})
    default_options = { placeholder: key.titleize, class: "margin-reset" }
    merged_options = default_options.merge(options)

    field_type = $FIELD_TYPES[key] || :text

    case field_type
    when :area
      f.text_area(key, merged_options.merge(rows: 4))
    when :date
      f.date_field(key, merged_options)
    else
      f.text_field(key, merged_options)
    end
  end
end
