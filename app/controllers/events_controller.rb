class EventsController < ApplicationController
  before_action :authorize_admin!, except: :get_current_event
  include WebApiRenderer
  attr_accessor :meta

  def dashboard
    @checked_in_numbers = current_event.attendees.checked_in.count
    @total = current_event.attendees.count

    render layout: 'event'
  end

  def content_setting
    @current_module = 6
    @event = current_event

    @restaurant = Restaurant.find_or_create_by(event: current_event)
    @latitude = @restaurant.latitude
    @longitude = @restaurant.longitude

    render layout: 'event'
  end

  def event_base_setting
    @current_module = 6
    @event = current_event
    render layout: 'event'
  end

  def welcome_page_setting
    @current_module = 6
    @event = current_event
    render layout: 'event'
  end

  def function_setting
    @current_module = 6
    @event = current_event
    render layout: 'event'
  end

  def update_function_setting
    @event = Event.find(params[:event_id])

    reset_event_function
    function_order = 1

    update_function_setting_params.each do |k , v|
      if '1'==v
        current_event.update! "#{k}_order": function_order, "#{k}": true
        function_order += 1
      end
    end
    redirect_to event_function_setting_path(current_event), flash: { success: '活动编辑成功' }
  end

  def update_welcome_page_setting
    @event = Event.find(params[:event_id])
    if @event.update(welcome_page_setting_params)
      redirect_to event_welcome_page_setting_path(current_event) , flash: { success: '活动编辑成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :edit
    end
  end

  def update_event_base_setting
    @event = Event.find(params[:event_id])
    if @event.update(event_base_params)
      redirect_to event_event_base_setting_path(current_event), flash: { success: '活动编辑成功' }
    else
      flash.now[:error] = @event.errors.full_messages
      render :edit
    end
  end

  def update_event_function_order
    self.meta = params
    reset_event_function
    for i in 0..(params['function_length'].to_i-1)
      function_name = params['function_list']['0']['function_name'] if 0==i
      function_name = params['function_list']['1']['function_name'] if 1==i
      function_name = params['function_list']['2']['function_name'] if 2==i
      function_name = params['function_list']['3']['function_name'] if 3==i
      function_name = params['function_list']['4']['function_name'] if 4==i
      function_name = params['function_list']['5']['function_name'] if 5==i
      function_name = params['function_list']['6']['function_name'] if 6==i
      function_name = params['function_list']['7']['function_name'] if 7==i
      case function_name
      when 'hotel_info'
        current_event.update hotel_info: true, hotel_info_order: (i+1)
      when 'admission_certificate'
        current_event.update admission_certificate: true, admission_certificate_order: (i+1)
      when 'session_schedule'
        current_event.update session_schedule: true, session_schedule_order: (i+1)
      when 'nearby_recommend'
        current_event.update nearby_recommend: true, nearby_recommend_order: (i+1)
      when 'seat_info'
        current_event.update seat_info: true, seat_info_order: (i+1)
      when 'outside_link'
        current_event.update outside_link: true, outside_link_order: (i+1)
      when 'interactive_answer'
        current_event.update interactive_answer: true, interactive_answer_order: (i+1)
      when 'lottery'
        current_event.update lottery: true, lottery_order: (i+1)
      end
    end

    render_ok []
  end

  def reset_event_function
    current_event.update admission_certificate: false,
      session_schedule: false,
      hotel_info: false,
      nearby_recommend: false,
      seat_info: false,
      outside_link: false,
      interactive_answer: false,
      lottery: false,
      admission_certificate_order: 0,
      session_schedule_order: 0,
      hotel_info_order: 0,
      nearby_recommend_order: 0,
      seat_info_order: 0,
      outside_link_order: 0,
      interactive_answer_order: 0,
      lottery_order: 0
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

  def show
    self.meta = params
    event = Event.find(params[:id])
    render_ok [ event ]
  end

  def index
    @events = Event.all.where(defunct: false).order(start: :DESC)
  end

  def set_current_event
    @events = Event.all.where(defunct: false).order(start: :DESC)
    @current_active_event = Event.find_by(is_current_event: true)
  end

  def update_current_event
    Event.update_all(is_current_event: false)
    event = Event.find(params[:event_id])
    event.update(is_current_event: true)
    redirect_to set_current_event_path, flash: { success: '设置成功' }
  end

  def get_current_event
    event = Event.find_by(is_current_event: true)
    redirect_to client_event_invites_path(event)
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

  def destroy
    @event = Event.find(params[:id])
    if @event.update(defunct: true)
      redirect_to events_path, flash: { success: '成功' }
    else
      redirect_to events_path, flash: { error: 'failure' }
    end
  end

  def update_function_setting_params
    params.require(:event).permit(:admission_certificate, :session_schedule, :hotel_info, :nearby_recommend, :seat_info, :outside_link, :interactive_answer, :lottery)
  end

  def welcome_page_setting_params
    params.require(:event).permit(:display_welcome_page, :welcome_page_logo, :welcome_bg, :text_inverse_color,:welcome_second_bg, :sessions_new_bg)
  end

  def event_base_params
    params.require(:event).permit(:domain_name, :title, :content, :head_photo, :event_logo, :wx_pic_logo, :seat_search_bg)
  end

private
  def event_param
    params.require(:event).permit(:name, :start, :end, :desc, :location, :event_link)
  end

  def event_settings_param
    params.require(:event).permit(:name, :start, :end, :desc, :location, :contact, :contact_number, :time_zone, :start_time, :end_time, :event_link)
  end
end
