module Shared
  module FormHelper
    FIELD_TYPES = {
      "notes" => :area,
      "production_year" => :date,
      "price" => :number,
      "displacement" => :number,
      "power" => :number,
      "customer_id" => :dynamic_dropdown,
      "fuel_type" => :regular_dropdown,
      "displacement" => :regular_dropdown,
      "power" => :regular_dropdown,
      "cylinders_num" => :regular_dropdown,
    }.freeze

    def render_form_field(f, key, area_options = {})
      default_options = { placeholder: key.titleize, class: "margin-reset" }

      field_type = FIELD_TYPES[key] || :text

      case field_type
      when :area
        f.text_area(key, default_options.merge(rows: area_options[:rows] || 4))
      when :date
        f.date_field(key, default_options)
      when :number
        f.number_field(key, default_options)
      when :dynamic_dropdown
        # Dynamic dropdown is currently only used for adding new customers.
        # TODO: Add a hash parameter to render_form_field and
        # reconsider how to handle it to avoid breaking logic for shared forms.
        link = link_to "Add New", new_customer_path, data: { turbo_frame: "add_new_modal" }
        select = f.select(key, all_customers_for_car)
        link + select
      when :regular_dropdown
        f.select(key, enum_keys(f.object.class, key))
      else
        f.text_field(key, default_options)
      end
    end

    def error_message_for(model, attribute)
      if model.errors[attribute].present?
        content_tag :small,
                    model.errors.full_messages_for(attribute).join(", "),
                    id: "#{attribute}_error",
                    class: "error-color"
      end
    end

    def enum_keys(klass, enum_name)
      klass.defined_enums[enum_name].keys
    end
  end
end
