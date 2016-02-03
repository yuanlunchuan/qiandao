class SeatsController < ApplicationController
  include WebApiRenderer
  layout 'event'
  before_action :set_current_module
  attr_accessor :meta

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

    if params[:classify]=='location'&&params[:enable_together]=='no'

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

    redirect_to event_seat_path(current_event, session, { table_num: params[:table_num], table_pernum: params[:table_pernum] })
  end

  def set_current_module
    @current_module = 2
  end

  private :set_current_module
end
