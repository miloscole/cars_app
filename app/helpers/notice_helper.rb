module NoticeHelper
  def notice_msg(object, name, created_updated_deleted)
    "#{object.class.to_s} #{name} was successfully #{created_updated_deleted}!"
  end
end
