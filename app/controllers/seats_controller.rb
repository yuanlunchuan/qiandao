class SeatsController < ApplicationController
  include WebApiRenderer
  layout 'event'
  before_action :set_current_module
  attr_accessor :meta

  def new
    @session = Session.new

    if params[:session_id]
      @session = Session.find(params[:session_id])
      @seats = Seat.session_is(@session) unless params[:reload_seat].present?

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
    @session = Session.find(params[:id])
  end

  def update
    self.meta = params

    first_seat = Seat.find(params[:first_seat])
    second_seat = Seat.find(params[:second_seat])

    temp_seat_table_row = first_seat.table_row
    temp_seat_table_col = first_seat.table_col

    first_seat.update(table_row: second_seat.table_row, table_col: second_seat.table_col)
    second_seat.update(table_row: temp_seat_table_row, table_col: temp_seat_table_col)

    render_ok []
  end

  def create
    session = Session.find(params[:session_id])

    if session.session_seat.present?
      session_seat = session.session_seat
      session_seat.total_table_count = params[:table_num]
      session_seat.per_table_num = params[:table_pernum]
    else
      session_seat = SessionSeat.new total_table_count: params[:table_num],
        per_table_num: params[:table_pernum],
        session: session
    end

    unless session_seat.save
      flash.now[:error] = session_seat.errors.full_messages
      render :new
      return
    end

    if params[:classify]=='location'&&params[:enable_together]=='no'
      seat_location_not_together
    end

    if params[:classify]=='location'&&params[:enable_together]=='yes'
      seat_location_can_together
    end

    redirect_to new_event_seat_path(session_id: session)
  end

  def seat_location_can_together
    session = Session.find(params[:session_id])
    city_list = Attendee.select("city").group("city").reorder('city').size
    city_collection = []

    city_list.each do |k,v|
      city_item = {}
      city_item['city_name'] = k
      city_item['city_count'] = v
      city_collection << city_item
    end

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
        attendees_size = attendees.size
        Seat.create session: session,
          attendee:  attendee,
          desc:      city_item['city_name'],
          table_row: row,
          table_col: col

        if params[:table_pernum].to_i==col
          row += 1
          col = 1
        else
          col += 1
        end
      end

    end
  end

  def seat_location_not_together
    session = Session.find(params[:session_id])
    city_list = Attendee.select("city").group("city").reorder('city').size
    city_collection = []

    city_list.each do |k,v|
      city_item = {}
      city_item['city_name'] = k
      city_item['city_count'] = v
      city_collection << city_item
    end

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
      i = 0
      attendees.each do |attendee|
        i += 1
        attendees_size = attendees.size
        Seat.create session: session,
          attendee:  attendee,
          desc:      city_item['city_name'],
          table_row: row,
          table_col: col

        if params[:table_pernum].to_i==col
          row += 1 if attendees_size!=i
          col = 1
        else
          col += 1
        end
      end
      row += 1
    end
  end

  def set_current_module
    @current_module = 2
  end

  private :set_current_module
end
