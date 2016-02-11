class Client::SeatsController < ApplicationController
  include WebApiRenderer
  attr_accessor :meta

  def show
    self.meta = params

    attendee = Attendee.find_by(id: params[:attendee_id])
    render_not_found '没有找到对应嘉宾' and return if attendee.blank?

    session = Session.find_by(id: params[:session_id])
    render_not_found '没有找到对应日程' and return if session.blank?

    seats = Seat.attendee_seat_is(attendee, session)

    render_not_found '没有找到座位信息' and return if seats.blank?

    render_ok [ seats.first.to_hash ]
  end
end
