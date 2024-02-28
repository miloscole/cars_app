module Shared
  module IndexHelper
    OBJECTS_PER_PAGE = 6

    def object_attributes(object, id_column_shown = false)
      attributes = object.attributes.to_h
      attributes.delete("id") unless id_column_shown
      attributes
    end

    def load_index_objects(klass, fields_for_load, &additional_query)
      params[:page] ||= 1
      current_page = params[:page].to_i

      query = klass.where(user_id: Current.user.id)

      if block_given?
        query = yield(query)
      end

      user_objects = query.select(fields_for_load.join(", "))

      @total_records = user_objects.size

      user_objects.limit(OBJECTS_PER_PAGE).offset((current_page - 1) * OBJECTS_PER_PAGE)
    end

    def previous_next_links
      current_page = params[:page].to_i
      total_pages = (@total_records.to_f / OBJECTS_PER_PAGE).ceil

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
