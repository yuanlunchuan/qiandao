class Client::SeatsController < ApplicationController
  include WebApiRenderer
  attr_accessor :meta

  def show
    self.meta = params

    attendee = Attendee.find_by(id: params[:attendee_id])
    render_not_found '没有找到对应嘉宾' and return if attendee.blank?

    show_seat_session = nil
    current_event.sessions.each do |session_item|
      show_seat_session = session_item.session_seat if session_item.session_seat.present?&&session_item.session_seat.display
    end

    render_not_found '座位在安排中' and return if show_seat_session.blank?
    seats = Seat.attendee_seat_is(attendee, show_seat_session)
    render_not_found '没查询到您的座位' and return if seats.blank?

    render_ok [ seats.first ]
  end
end
