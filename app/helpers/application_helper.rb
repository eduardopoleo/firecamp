module ApplicationHelper
  def bootstrap_class_for flash_type
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    }[flash_type.to_sym] || flash_type.to_
  end

  def datetime_for_view(object)
    object.created_at.strftime("%b %d, %Y")
  end
end
