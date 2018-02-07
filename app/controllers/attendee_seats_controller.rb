class AttendeeSeatsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :set_module
  skip_before_action :verify_authenticity_token
  include WebApiRenderer
  attr_accessor :meta
  layout 'client'

  def new
    session[:search_seat_session_id] = params[:session_id]
  end

  def show
    self.meta = params
    session = Session.find(params[:session_id])
    attendees = Attendee.rfid_is(params[:keyword])
    attendees = Attendee.token_is(params[:keyword]) if attendees.blank?
    if session.present?&&attendees.present?
      @attendee = attendees.first
      @session_seat = session.session_seat
      @seat = Seat.attendee_seat_is(attendees.first, session).first
      resonse_hash = {
        seat: @seat,
        attendee: attendees.first,
        session_seat: @session_seat
      }
      render_ok [ resonse_hash ] if 'json'==params['format']
    else
      render_not_found [ 'not fund' ] if 'json'==params['format']
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