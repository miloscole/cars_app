module ApplicationHelper
  def page_btn_links(model, current_action)
    back_link = link_to "Back to #{model.class.to_s.downcase.pluralize}", { action: "index" },
                        class: "secondary outline",
                        role: "button"

    case current_action
    when "edit", "update"
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
    when "new", "create", "delete"
      back_link
    else
      nil
    end
  end

  def page_title(model)
    case action_name
    when "index"
      #"Sending class directly as a model for index case to pick up the name,
      #since I do not have any instance on the object before geting them all from db."
      "#{model.to_s.pluralize}"
    when "new", "create"
      "New #{model.class.to_s.downcase}"
    when "edit", "update"
      "Editing #{model.class.to_s.downcase}"
    else
      nil
    end
  end

  def truncate_value(value, num_of_chars = 20)
    return "" unless value.present?
    return value unless value.length > num_of_chars

    value.truncate(num_of_chars)
  end

  def search_objects(objects, searchable_fields, klass, query)
    objects.where(
      searchable_fields.map { |field| "#{klass.arel_table.name}.#{field} LIKE :query" }.join(" OR "),
      query: "%#{query}%",
    )
  end

  def visible_attributes(object, fields_to_remove = [])
    unless fields_to_remove.is_a?(Array)
      raise ArgumentError, "fields_to_remove must be array"
    end

    all_fields = fields_to_remove + ["id", "created_at", "updated_at", "user_id"]

    object.attributes.except(*all_fields)
  end
end
