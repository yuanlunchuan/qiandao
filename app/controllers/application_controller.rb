class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_admin
    @current_admin ||= Admin.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_event
    @current_event ||= Event.find(params[:event_id]) if params[:event_id]
  end

  def authorize_admin!
    redirect_to sign_in_path(back_url: request.original_url) if current_admin.nil?
  end

  helper_method :current_admin, :current_event
end
