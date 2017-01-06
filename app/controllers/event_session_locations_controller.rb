class EventSessionLocationsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @session_locations = current_event.session_locations
  end

  def new
    @event_session = SessionLocation.new
  end

  def edit
    @event_session = current_event.session_locations.find(params[:id])
  end

  def create
    @session_location = current_event.session_locations.new session_location_params
    if @session_location.save
      redirect_to event_event_session_locations_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session_location.errors.full_messages
      render :new
    end
  end

  def update
    @session_location = current_event.session_locations.find(params[:id])

    if @session_location.update(session_location_params)
      redirect_to event_event_session_locations_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @session_location.errors.full_messages
      render :edit
    end
  end

  def set_current_module
    @current_module = 0
  end

  def session_location_params    
    params.require(:session_location).permit(:location_name)
  end

  private :set_current_module, :session_location_params
end