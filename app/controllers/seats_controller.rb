class SeatsController < ApplicationController
  include WebApiRenderer
  layout 'event'
  before_action :set_current_module
  skip_before_action :verify_authenticity_token
  attr_accessor :meta

  def destroy
    seat = Seat.find(params[:id])
    seat.destroy
    redirect_to event_seats_path(current_event, display_type: 'attendee', session_id: params[:session_id])
  end

  def dele_attendee_seat
    self.meta = params

    session = Session.find(params[:session_id])
    attendee = Attendee.find(params[:attendee_id])
    seat = Seat.attendee_seat_is(attendee, session).first
    seat.destroy
    render_ok []
  end

  def update_attendee_seat
    self.meta = params

    session = Session.find(params[:session_id])
    attendee = Attendee.find(params[:attendee_id])
    seat = Seat.attendee_seat_is(attendee, session).first
    if seat.present?
      seat.update(table_row: params[:table_row], table_col: params[:table_col])
    else
      seat = Seat.create session: session,
        attendee:  attendee,
        table_row: params[:table_row],
        table_col: params[:table_col]
    end

    render_ok [ seat ]
  end

  def search_by_session_row
    self.meta = params
    session = Session.find(params[:session_id])
    seats = Seat.search_by_session_row(session, params[:table_row]).reorder('table_col ASC')
    collection = []

    collection << session.session_seat
    seats.each do |seat|
      collection << seat
    end

    render_ok collection
  end

  def get_session_seat
    self.meta = params

    session = Session.find(params[:session_id])
    current_seat = session.session_seat

    render_ok [ current_seat ] if current_seat.present?
    render_not_found '没有找到安排信息' if current_seat.blank?
  end

  def get_seats_tablerow
    self.meta = params
    session = Session.find(params[:session_id])

    current_seats = Seat.session_is session
    seats_list = current_seats.select('table_row').group('table_row').size
    collection = []
    per_table_num = session.session_seat.per_table_num
    for i in 1..session.session_seat.total_table_count
      item = i
      item = "第#{i}桌（排）坐满" if seats_list[i].to_i>=per_table_num
      collection << item
    end

    render_ok collection
  end

  def arrange_seat
    self.meta = params

    session = Session.find(params[:session_id])
    table_col = 0
    params[:attendees_id].each do |attendee_id|
      table_col += 1
      attendee = Attendee.find(attendee_id)
      seat = Seat.new session: session,
        attendee:  attendee,
        table_row: params[:table_row],
        table_col: table_col
      seat.save
    end
    render_ok []
  end

  def show

  end

  def index
    @session = Session.find(params[:session_id])
    @current_session_seat = @session.session_seat
    @attendees = current_event.attendees
    @attendees = current_event.attendees.contains(params[:keyword]) if params[:keyword].present?
    if 'true'==params[:has_arranged]
      @attendees = current_event.attendees.has_arranged(@session)
    elsif 'false'==params[:has_arranged]
      @attendees = current_event.attendees.not_arrange(@session)
    end
    @attendees = @attendees.page(params[:page])
  end

  def search_attendee
    self.meta = params

    @session = Session.find(params[:session_id])
    @attendees = current_event.attendees.not_arrange(@session).contains(params[:keyword]) if params[:keyword].present?
    collection = []
    @attendees.each do |attendee|
      item = attendee.to_hash
      item[:owner_attendee_name] = attendee.owner_attendee.try(:name)
      item[:seller_name] = attendee.seller.try(:name)
      item[:category_name] = attendee.category.try(:name)
      collection << item
    end

    render_ok collection
  end

  def new
    if 'show_attendees'==params[:current_action]
      @session = Session.find(params[:session_id])

      @table_rows = []
      for table_row in 1..@session.session_seat.total_table_count
        @table_rows << [table_row, table_row]
      end
      @attendees = current_event.attendees.not_arrange(@session)
      @attendees = current_event.attendees.not_arrange(@session).contains(params[:keyword]) if params[:keyword].present?
      @attendees = @attendees.page(params[:page])
      @current_session_seat = @session.session_seat
      @current_row = (@session.seats.maximum("table_row")||0)+1

      if params[:table_row].present?
        @current_row = params[:table_row]
        @current_table = Seat.search_by_session_row(@session, params[:table_row])
      end
    end
  end

  #更新座位安排
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
      session_seat.total_table_count = params[:total_table_count]
      session_seat.per_table_num = params[:per_table_num]
      clear_current_session_seat session
    else
      session_seat = SessionSeat.new total_table_count: params[:total_table_count],
        per_table_num: params[:per_table_num],
        session: session
    end
    session_seat.properties[:unit] = params[:unit]
    session_seat.properties[:set_table_num] = params[:set_table_num]
    session_seat.save

    unless session_seat.save
      flash.now[:error] = session_seat.errors.full_messages
      render :new
      return
    end
    redirect_to new_event_seat_path(current_action: 'show_attendees', session_id: params[:session_id])
  end

  def clear_current_session_seat session
    current_seat_exist = Seat.session_is(session).should_delete(params[:total_table_count].to_i, params[:per_table_num].to_i)
    if current_seat_exist.present?
      current_seat_exist.each do |seat|
        seat.destroy
      end
    end
  end

  def set_current_module
    @current_module = 2
  end

  private :set_current_module
end
