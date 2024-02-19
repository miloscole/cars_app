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

  def truncate_value(value)
    return "" unless value.present?
    return value unless value.length > 20

    value.truncate(20)
  end
end
