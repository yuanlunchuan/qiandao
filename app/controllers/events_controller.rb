class EventsController < ApplicationController
  before_action :authorize_admin!

  def dashboard

    @checked_in_numbers = current_event.attendees.checked_in.count
    @total = current_event.attendees.count

    render layout: 'event'
  end

  def event_base_setting
    @current_module = 6
    @event = current_event
    render layout: 'event'
  end

  def update_event_base_setting
    @event = Event.find(params[:event_id])
    if @event.update(event_base_params)
      redirect_to dashboard_path , flash: { success: '活动编辑成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :edit
    end
  end

  def settings
    render layout: 'event'
  end

  def save_settings
    @event = Event.find(params[:event_id])

    if @event.update(event_settings_param)
      redirect_to event_dashboard_path(@event), flash: { success: '编辑成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :edit
    end
  end

  def index
    @events = Event.all.order(id: :desc)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_param)
    if @event.save
      redirect_to dashboard_path, flash: { success: '活动创建成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_param)
      redirect_to dashboard_path , flash: { success: '活动编辑成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :edit
    end
  end

  def event_base_params
    params.require(:event).permit(:domain_name, :title, :content, :head_photo, :event_logo)
  end

private
  def event_param
    params.require(:event).permit(:name, :start, :end, :desc, :location, :event_link)
  end

  def event_settings_param
    params.require(:event).permit(:name, :start, :end, :desc, :location, :contact, :contact_number, :time_zone, :start_time, :end_time, :event_link)
  end
end
