module NoticeHelper
  def updated_notice(object)
    "#{object.class.to_s} #{object.id} was successfully updated."
  end

  def created_notice(object)
    "#{object.class.to_s} #{object.id} was successfully created."
  end

  def deleted_notice(object)
    "#{object.class.to_s} #{object.id} was successfully deleted."
  end
end
