class SeatsController < ApplicationController
  include WebApiRenderer
  layout 'event'
  before_action :set_current_module
  skip_before_action :verify_authenticity_token
  attr_accessor :meta

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
    @attendees = current_event.attendees.page(params[:page])
    @attendees = current_event.attendees.contains(params[:keyword]).page(params[:page]) if params[:keyword].present?
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
      @current_row = (@session.seats.maximum("table_row")||0)+1
      @current_session_seat = @session.session_seat
    end

    # @session = Session.new
    # @attendees = current_event.attendees
    # @attendees = @attendees.page(params[:page]).includes(:category)

    # if params[:session_id]
    #   @session = Session.find(params[:session_id])
    #   @seats = Seat.session_is(@session) unless params[:reload_seat].present?
    # end
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
      total_table_count = session_seat.total_table_count
      per_table_num = session_seat.per_table_num
      if (total_table_count<params[:total_table_count].to_i)||(total_table_count<params[:total_table_count].to_i)
        clear_other_seat(params[:total_table_count].to_i, params[:total_table_count].to_i)
      end
      session_seat.total_table_count = params[:total_table_count]
      session_seat.per_table_num = params[:per_table_num]
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
    return
    #------------------------------------------
    if params[:classify]=='location'&&params[:enable_together]=='no'
      seat_location_not_together
    end

    if params[:classify]=='location'&&params[:enable_together]=='yes'
      seat_location_can_together
    end

    if params[:classify]=='seller'&&params[:enable_together]=='no'
      seat_seller_not_together
    end

    if params[:classify]=='seller'&&params[:enable_together]=='yes'
      seat_seller_can_together
    end

    redirect_to new_event_seat_path(session_id: session) unless @should_break
  end

  def clear_other_seat(current_table_row, current_table_col)
    
  end

  def seat_seller_not_together
    session = Session.find(params[:session_id])
    seller_collections = seller_collection
    clear_current_session_seat session
    @should_break = false

    row = 1
    seller_collections.each do |seller_item|
      col = 0
      if params[:sub_attendee_enable] == 'yes'
        current_seller_attendees = current_event.attendees.seller_id_is(seller_item['seller_id'])
      else
        current_seller_attendees = current_event.attendees.is_sub_attendees.seller_id_is(seller_item['seller_id'])
      end
      current_seller_attendees.each do |attendee|
        if params[:table_pernum].to_i==col
          row += 1
          col = 1
        else
          col += 1
        end

        break if @should_break
        if params[:auto_increase]=='no'&&params[:table_num].to_i < row
          @should_break = true
          redirect_to new_event_seat_path(session_id: session), flash: {error: '不能容纳下所有嘉宾， 请重新设置桌数'}
          break
        end

        Seat.create session: session,
          attendee:  attendee,
          desc:      seller_item['seller_id'],
          table_row: row,
          table_col: col
      end
      row += 1 if current_seller_attendees.present?
    end

  end

  def seat_seller_can_together
    session = Session.find(params[:session_id])
    seller_collections = seller_collection
    clear_current_session_seat session

    row = 1
    col = 0
    seller_collections.each do |seller_item|
      if params[:sub_attendee_enable] == 'yes'
        current_seller_attendees = current_event.attendees.seller_id_is(seller_item['seller_id'])
      else
        current_seller_attendees = current_event.attendees.is_sub_attendees.seller_id_is(seller_item['seller_id'])
      end
      current_seller_attendees.each do |attendee|
        if params[:table_pernum].to_i==col
          row += 1
          col = 1
        else
          col += 1
        end

        break if @should_break
        if params[:auto_increase]=='no'&&params[:table_num].to_i < row
          @should_break = true
          redirect_to new_event_seat_path(session_id: session), flash: {error: '不能容纳下所有嘉宾， 请重新设置桌数'}
          break
        end

        Seat.create session: session,
          attendee:  attendee,
          desc:      seller_item['seller_id'],
          table_row: row,
          table_col: col
      end
    end
  end

  def seller_collection
    seller_list = current_event.attendees.select("seller_id").group("seller_id").reorder('seller_id').size
    seller_collection = []

    seller_list.each do |k,v|
      seller_item = {}
      seller_item['seller_id'] = k
      seller_item['seller_count'] = v
      seller_collection << seller_item
    end

    seller_collection
  end

  def city_collection
    city_list = current_event.attendees.select("city").group("city").reorder('city').size

    city_collection = []

    city_list.each do |k,v|
      city_item = {}
      city_item['city_name'] = k
      city_item['city_count'] = v
      city_collection << city_item
    end

    city_collection
  end

  def clear_current_session_seat session
    current_seat_exist = Seat.session_is(session)
    if current_seat_exist.present?
      current_seat_exist.each do |seat|
        seat.destroy
      end
    end
  end

  def seat_location_not_together
    session = Session.find(params[:session_id])
    city_collections = city_collection
    clear_current_session_seat session
    @should_break = false

    row = 1
    city_collections.each do |city_item|
      col = 0
      if params[:sub_attendee_enable] == 'yes'
        current_city_attendees = current_event.attendees.city_is(city_item['city_name'])
      else
        current_city_attendees = current_event.attendees.is_sub_attendees.city_is(city_item['city_name'])
      end
      current_city_attendees.each do |attendee|
        if params[:table_pernum].to_i==col
          row += 1
          col = 1
        else
          col += 1
        end

        break if @should_break
        if params[:auto_increase]=='no'&&params[:table_num].to_i < row
          @should_break = true
          redirect_to new_event_seat_path(session_id: session), flash: {error: '不能容纳下所有嘉宾， 请重新设置桌数'}
          break
        end

        Seat.create session: session,
          attendee:  attendee,
          desc:      city_item['city_name'],
          table_row: row,
          table_col: col
      end
      row += 1 if current_city_attendees.present?
    end
  end

  def seat_location_can_together
    session = Session.find(params[:session_id])
    city_collections = city_collection
    clear_current_session_seat session

    row = 1
    col = 0
    city_collections.each do |city_item|
      if params[:sub_attendee_enable] == 'yes'
        current_city_attendees = current_event.attendees.city_is(city_item['city_name'])
      else
        current_city_attendees = current_event.attendees.is_sub_attendees.city_is(city_item['city_name'])
      end
      current_city_attendees.each do |attendee|
        if params[:table_pernum].to_i==col
          row += 1
          col = 1
        else
          col += 1
        end

        break if @should_break
        if params[:auto_increase]=='no'&&params[:table_num].to_i < row
          @should_break = true
          redirect_to new_event_seat_path(session_id: session), flash: {error: '不能容纳下所有嘉宾， 请重新设置桌数'}
          break
        end

        Seat.create session: session,
          attendee:  attendee,
          desc:      city_item['city_name'],
          table_row: row,
          table_col: col
      end
    end
  end

  def set_current_module
    @current_module = 2
  end

  private :set_current_module
end
