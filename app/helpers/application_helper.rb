module ApplicationHelper
  def page_btn_links(model, current_action)
    back_link = link_to "Back to #{model.class.to_s.downcase.pluralize}", { action: "index" },
                        class: "secondary outline",
                        role: "button"

    case current_action
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
    when "new", "delete"
      back_link
    else
      nil
    end
  end

  def page_title(model)
    case action_name
    when "index"
      #"Strange situation for the index action: model.class will not work as expected (need to check this)."
      "#{model.to_s.pluralize}"
    when "new"
      "New #{model.class.to_s.downcase}"
    when "edit"
      "Editing #{model.class.to_s.downcase}"
    else
      nil
    end
  end
end
