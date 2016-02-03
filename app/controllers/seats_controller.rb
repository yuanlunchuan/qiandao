class SeatsController < ApplicationController
  layout 'event'
  before_action :set_current_module

  def new
    #@session = Session.find(params[:session_id]||1)
    @session =[]
    if params[:session_id]

      params[:has_photo]  ||= '0'
      params[:has_avatar] ||= '0'
      @attendees = current_event.attendees
      @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
      @attendees = @attendees.has_photo if params[:has_photo] == '1'
      @attendees = @attendees.has_avatar if params[:has_avatar] == '1'
      @attendees = @attendees.does_not_have_photo  if params[:has_photo] == '-1'
      @attendees = @attendees.does_not_have_avatar if params[:has_avatar] == '-1'
      @attendees = @attendees.does_not_processed_avatar if params[:has_avatar] == '-2'
      @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
      @attendees = @attendees.page(params[:page]).includes(:category)
    end
  end

  def index
    
  end

  def show

  end

  def create
    session = Session.find(params[:session_id])

    if session.seat.present?
      #session.seat.update table_num: params[:table_num], per_table_num: params[:table_pernum]
    else
      #Seat.create table_num: params[:table_num], per_table_num: params[:table_pernum], session: session
    end

    if params[:classify]=='location'&&params[:enable_together]=='no'

      city_list = Attendee.select("city").group("city").reorder('city').size
      city_collection = []

      city_list.each do |k,v|
        city_item = {}
        city_item['city_name'] = k
        city_item['city_count'] = v
        city_collection << city_item
      end

      # row = params[:table_num]
      # col = params[:table_pernum]

      current_seat_exist = Seat.session_is(session)

      if current_seat_exist.present?
        current_seat_exist.each do |seat|
          seat.destroy
        end
      end

      @attendees = current_event.attendees

      row = 1
      city_collection.each do |city_item|
        attendees = current_event.attendees.city_is(city_item['city_name'])
        col = 1
        attendees.each do |attendee|
          Seat.create session: session,
            attendee:  attendee,
            desc:      city_item['city_name'],
            table_row: row,
            table_col: col

          if params[:table_pernum]==col
            col = 1
          else
            col += 1
          end
        end
        row += 1
      end

    end

    redirect_to event_seat_path(current_event, '12', { table_num: params[:table_num], table_pernum: params[:table_pernum] })
  end

  def set_current_module
    @current_module = 2
  end

  private :set_current_module
end
