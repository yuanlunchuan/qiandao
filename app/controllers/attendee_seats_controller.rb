class AttendeeSeatsController < ApplicationController
  before_action :set_module
  skip_before_action :verify_authenticity_token
  layout 'client'

  def new
    
  end

  def create
    attendees = Attendee.rfid_is(params[:key_word])
    if 0==attendees.size
      attendees = Attendee.mobile_is(params[:key_word])
    end

    if 0==attendees.size
      attendees = Attendee.attendee_name_is(params[:key_word])
    end

    if 0==attendees.size
      flash.now[:error] = '该嘉宾不存在'
      render :new
    end
    @session = Session.find(params[:session_id])
    @attendee = attendees.first
    seats = Seat.attendee_seat_is(@attendee, @session)
    if seats.present?
      @seat = seats.first
      redirect_to event_attendee_seat_path(current_event, @seat)
    else
      flash.now[:error] = '座位信息为空'
      render :new 
    end

  end

  def show
    @seat = Seat.find(params[:id])
    @attendee = @seat.attendee
  end

  def index

  end

  def set_module
    @current_module = 'seat_search'
  end

  private :set_module
end