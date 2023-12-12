module ApplicationHelper
  def visible_attributes(object, removed_attributes = [])
    unless removed_attributes.is_a?(Array)
      raise ArgumentError, "removed_attributes must be arrays"
    end
    all_keys_to_remove = removed_attributes + ["id", "created_at", "updated_at"]
    object.attributes.delete_if { |key, _| all_keys_to_remove.include?(key) }
  end
end
