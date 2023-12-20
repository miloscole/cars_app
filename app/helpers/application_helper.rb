module ApplicationHelper
  FIELD_TYPES = {
    "notes" => :area,
    "production_year" => :date,
    "price" => :number,
    "customer_id" => :dropdown,
  }.freeze

  def render_form_field(f, key)
    default_options = { placeholder: key.titleize, class: "margin-reset" }

    field_type = FIELD_TYPES[key] || :text

    case field_type
    when :area
      f.text_area(key, default_options.merge(rows: 4))
    when :date
      f.date_field(key, default_options)
    when :number
      f.number_field(key, default_options.merge(type: "number"))
    when :dropdown
      link = link_to "Add New", new_customer_path, data: { turbo_frame: "add_new_modal" }
      select = f.select(key, get_all_customers)
      link + select
    else
      f.text_field(key, default_options)
    end
  end

  def visible_attributes(object, attributes_to_remove = [])
    unless attributes_to_remove.is_a?(Array)
      raise ArgumentError, "removed_attributes must be arrays"
    end

    all_keys_to_remove = attributes_to_remove + ["id", "created_at", "updated_at"]

    object.attributes.delete_if { |key, _| all_keys_to_remove.include?(key) }
  end

  def error_message_for(model, attribute)
    if model.errors[attribute].present?
      content_tag :small,
                  model.errors.full_messages_for(attribute).join(", "),
                  id: "#{attribute}_error",
                  class: "error-color"
    end
  end

  def page_btn_links(model)
    back_link = link_to "Back to #{model.class.to_s.downcase.pluralize}", { action: "index" },
                        class: "secondary outline",
                        role: "button"

    case action_name
    when "edit"
      show_link = link_to "Show this #{model.class.to_s.downcase}", { action: "show" },
                          class: "outline",
                          role: "button"

      "#{show_link} #{back_link}".html_safe
    when "show"
      edit_link = link_to "Edit #{model.class.to_s.downcase}", { action: "edit" },
                          class: "outline",
                          role: "button"

      delete_link = link_to "Delete this #{model.class.to_s.downcase}", { action: "delete" },
                            class: "secondary outline",
                            role: "button"

      "#{edit_link} #{delete_link} #{back_link}".html_safe
    else
      back_link
    end
  end

  def page_title(model)
    if action_name != "index"
      first_word = (action_name == "edit") ? "Editing" : "New"
      "#{first_word} #{model.class.to_s.downcase}"
    else
      model.to_s.pluralize
    end
  end
end
