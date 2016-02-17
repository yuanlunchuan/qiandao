class SeatsController < ApplicationController
  include WebApiRenderer
  layout 'event'
  before_action :set_current_module
  attr_accessor :meta

  def new
     @attendees = current_event.attendees
    @attendees = @attendees.page(params[:page])
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
      session_seat.total_table_count = params[:table_num]
      session_seat.per_table_num = params[:table_pernum]
    else
      session_seat = SessionSeat.new total_table_count: params[:table_num],
        per_table_num: params[:table_pernum],
        session: session
    end

    unless session_seat.save
      flash.now[:error] = session_seat.errors.full_messages
      @attendees = current_event.attendees
      @attendees = @attendees.page(params[:page]).includes(:category)
      render :new
      return
    end

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
