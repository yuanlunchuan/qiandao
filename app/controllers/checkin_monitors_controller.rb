class CheckinMonitorsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @sessions = current_event.sessions
  end

  def edit
    @session = current_event.sessions.find(params[:id])
  end

  def update
    @session = current_event.sessions.find(params[:id])

    if @session.update(session_params)
      redirect_to event_checkin_monitors_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session.errors.full_messages
      render :edit
    end
  end

  def destroy
    @session = current_event.sessions.find(params[:id])
    @session.destroy

    redirect_to event_checkin_monitors_path(current_event)
  end

  def set_current_module
    @current_module = 3
  end

  def session_params
    params.require(:session).permit(:name, :desc, :start_time, :end_time, :start_date, :checkin_enabled, :company_checkin, :hidden, :question_enabled)
  end

  private :set_current_module, :session_params

end