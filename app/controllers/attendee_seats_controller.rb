class AttendeeSeatsController < ApplicationController
  before_action :set_module
  skip_before_action :verify_authenticity_token
  layout 'client'

  def new
    session[:search_seat_session_id] = params[:session_id]
  end

  def create
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
    session = Session.find(params[:session_id])
    attendees = Attendee.rfid_is(params[:keyword])
    attendees = Attendee.token_is(params[:keyword]) if attendees.blank?
    if session.present?&&attendees.present?
      @attendee = attendees.first
      @seat = Seat.attendee_seat_is(attendees.first, session).first
    end
  end

  def index
    render layout: "site"
  end

  def set_module
    @current_module = 'seat_search'
  end

  private :set_module
end