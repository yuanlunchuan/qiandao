class Client::SeatsController < ApplicationController
  include WebApiRenderer
  attr_accessor :meta

  def show
    self.meta = params

    attendee = Attendee.find_by(id: params[:attendee_id])
    render_not_found '没有找到对应嘉宾' and return if attendee.blank?

    show_seat_session = nil
    current_event.sessions.each do |session_item|
      show_seat_session = session_item if session_item.session_seat.present?&&session_item.session_seat.display
    end

    render_not_found '座位在安排中' and return if show_seat_session.blank?
    seats = Seat.attendee_seat_is attendee, show_seat_session
    render_not_found '没查询到您的座位' and return if seats.blank?

    current_table_seats = Seat.search_by_session_row show_seat_session, seats.first.table_row
    attendees = []
    current_table_seats.each do |seat|
      attendees << Attendee.find_by(id: seat.attendee_id).name
    end
    
    collection = []
    item = {}
    item = seats.first.to_hash

    item[:properties] = show_seat_session.session_seat.properties
    item[:attendees] = attendees
    collection << item

    render_ok collection
  end
end
