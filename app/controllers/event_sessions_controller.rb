class EventSessionsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'
  def set_current_module
    @current_module = 0
  end

  def index
    @sessions = current_event.sessions
  end

  def new
    @session = current_event.sessions.build
  end

  def create
    @session = current_event.sessions.new(session_params)

    if @session.save
      redirect_to event_sessions_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session.errors.full_messages
      render :new
    end
  end

  def edit
    @session = current_event.sessions.find(params[:id])
  end

  def update
    @session = current_event.sessions.find(params[:id])

    if @session.update(session_params)
      redirect_to event_sessions_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session.errors.full_messages
      render :edit
    end
  end


  def destroy
    @session = current_event.sessions.find(params[:id])
    @session.destroy

    redirect_to event_sessions_path
  end

private

  def session_params
    params.require(:session).permit(:name, :desc, :start_time, :end_time, :start_date, :checkin_enabled, :company_checkin, :hidden, :question_enabled, :session_location_id)
  end
end
