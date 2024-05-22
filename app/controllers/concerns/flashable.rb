module Flashable
  extend ActiveSupport::Concern

  def success_msg(options = {})
    return flash["success"] = options[:custom] unless options[:custom].nil?

    expected_keys = [:for, :with, :action]
    unexpected_keys = options.keys - expected_keys

    return flash["success"] = "Action succeeded!" if options.empty? || unexpected_keys.present?

    action = action_name
    action = "delete" if action_name == "destroy"

    msg_for = get_obj_name

    flash["success"] = "#{(options[:for] || msg_for).capitalize} " \
                       "#{options[:with]} was successfully " \
                       "#{options[:action] || action}d!"
  end

  def error_msg(custom = nil)
    error = set_error_msg custom
    flash["error"] = error
  end

  def error_msg_now(custom = nil)
    error = set_error_msg custom
    flash.now["error"] = error
  end

  private

  def get_obj_name
    self.class.name.gsub("Controller", "").singularize
  end

  def set_error_msg(custom = nil)
    custom = "You are not authorized to access this #{get_obj_name.downcase}" if custom == :not_authorized
    custom ||= "Something went wrong, please try again"
  end
end
