module Shared
  module IndexHelper
    def visible_attributes(object, attributes_to_remove = [])
      unless attributes_to_remove.is_a?(Array)
        raise ArgumentError, "removed_attributes must be arrays"
      end

      all_keys_to_remove = attributes_to_remove + ["id", "created_at", "updated_at", "user_id"]

      object.attributes.delete_if { |key, _| all_keys_to_remove.include?(key) }
    end

    def load_index_objects(model)
      per_page = 6
      params[:page] ||= 1
      page = params[:page].to_i

      user_objects = model.where(user_id: Current.user.id)

      total_records = user_objects.size
      total_pages = (total_records.to_f / per_page).ceil

      @show_next_link = page < total_pages

      user_objects.limit(per_page).offset((page - 1) * per_page)
    end

    def previous_next_links
      show_previous_link = params[:page].to_i > 1
      previous_link = link_to "< Previous", action: "index", page: (params[:page].to_i - 1) if show_previous_link
      next_link = link_to "Next >", action: "index", page: (params[:page].to_i + 1) if @show_next_link
      space_between = " | " if show_previous_link && @show_next_link

      space_between ||= ""

      content = previous_link.to_s + space_between + next_link.to_s
      content_tag(:footer, content.html_safe) if show_previous_link || @show_next_link
    end
  end
end
