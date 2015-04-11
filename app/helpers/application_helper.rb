module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "success"   # Green
      when "error"
        "danger"    # Red
      when "alert"
        "warning"   # Yellow
      when "notice"
        "info"      # Blue
      else
        flash_type.to_s
    end
  end

  def datetime_for_view(object)
    object.created_at.strftime("%b %d, %Y")
  end
end
