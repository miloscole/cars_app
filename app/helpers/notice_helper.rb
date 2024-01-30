module NoticeHelper
  def notice_msg(object, created_updated_deleted)
    "#{object.class.to_s} #{object.id} was successfully #{created_updated_deleted}!"
  end
end
