module Shared
  module IndexHelper
    def object_attributes(object, id_column_shown = false)
      attributes = object.attributes.to_h
      attributes.delete("id") unless id_column_shown
      attributes
    end

    def previous_next_links(klass)
      params[:page] ||= 1
      current_page = params[:page].to_i
      total_records = klass.where(user_id: Current.user.id).count
      total_pages = (total_records.to_f / OBJECTS_PER_PAGE).ceil

      show_next_link = current_page < total_pages
      show_previous_link = current_page > 1

      previous_link = link_to "< Previous", action: "index", page: (current_page - 1) if show_previous_link
      next_link = link_to "Next >", action: "index", page: (current_page + 1) if show_next_link
      space_between = " | " if show_previous_link && show_next_link

      space_between ||= ""

      content = previous_link.to_s + space_between + next_link.to_s
      content_tag(:footer, content.html_safe) if show_previous_link || show_next_link
    end
  end
end
