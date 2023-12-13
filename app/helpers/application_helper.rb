module ApplicationHelper
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
    back_link = link_to "Back to #{model.class.to_s.downcase.pluralize}", { action: "index" }
    case action_name
    when "edit"
      show_link = link_to "Show this #{model.class.to_s.downcase}", { action: "show" }
      "#{show_link} #{back_link}".html_safe
    when "show"
      edit_link = link_to "Edit #{model.class.to_s.downcase}", { action: "edit" }
      delete_link = link_to "Delete this #{model.class.to_s.downcase}", { action: "delete" }

      "#{edit_link} #{delete_link} #{back_link}".html_safe
    else
      back_link
    end
  end
end
