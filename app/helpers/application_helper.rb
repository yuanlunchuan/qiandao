module ApplicationHelper
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type]
  end

  def is_active_controller(controller_name)
    params[:controller] == controller_name ? "active" : nil
  end

  def is_active_item(controller_name, action_name=nil)
    if action_name.present?
      (params[:action] == action_name && params[:controller] == controller_name) ? "background-color: #999" : nil
    else
      params[:controller] == controller_name ? "background-color: #999" : nil
    end
  end

  def is_active_action(action_name, controller_name = nil)
    if controller_name
      (params[:action] == action_name && params[:controller] == controller_name) ? "active" : nil
    else
      params[:action] == action_name ? "active" : nil
    end
  end

end
