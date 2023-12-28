module ApplicationHelper
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
