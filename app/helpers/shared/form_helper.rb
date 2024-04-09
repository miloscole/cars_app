module Shared
  module FormHelper
    include FormConfig

    def render_form_field(f, key, options = {})
      default_options = { placeholder: key.titleize, class: "margin-reset" }

      field_type = SPECIFIC_FIELD_TYPES[key] || :text

      case field_type
      when :area
        f.text_area(key, default_options.merge(rows: options[:area_rows] || 4))
      when :date
        f.date_field(key, default_options)
      when :number
        f.number_field(key, default_options)
      when :dynamic_dropdown
        object_name = key.titleize.downcase

        link = link_to "Add New", send("new_#{object_name}_path"), data: { turbo_frame: "add_new_modal" }

        dd_options = f.object.class
          .send("load_#{object_name.pluralize}")
          .unshift(["Select a #{object_name}...", ""])

        select = f.select(key, dd_options)

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
