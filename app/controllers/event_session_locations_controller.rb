class EventSessionLocationsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @sessions = current_event.sessions
  end

  def new
    
  end

  def edit
    @session = current_event.sessions.find(params[:id])
  end

  def update
    @session = current_event.sessions.find(params[:id])

    if @session.update(session_params)
      redirect_to event_event_session_locations_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session.errors.full_messages
      render :edit
    end
  end

  def set_current_module
    @current_module = 0
  end

  def session_params    
    params.require(:session).permit(:name, :location, :baidu_map_location_url, :contact_name, :contact_phone_number)
  end

  private :set_current_module, :session_params
end