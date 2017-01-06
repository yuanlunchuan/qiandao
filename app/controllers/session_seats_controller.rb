class SessionSeatsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  layout 'event'
  before_action :set_current_module

  def create
    session = Session.find_by(id: params[:session_id])
    if params[:session_id].blank?
      redirect_to edit_event_session_seat_path(current_event, '~'), flash: {error: '请选择日程'}
      return
    end

    current_event.sessions.each do |session_item|
      if session_item.session_seat.present?
        session_item.session_seat.update(display: false)
      end
    end
    @session_seat = session.session_seat
    @session_seat.update(display: true)
    redirect_to edit_event_session_seat_path(current_event, '~'), flash: {success: '设置成功'}
  end

  def edit
    current_event.sessions.each do |session|
      @session_seat =session.session_seat if session.session_seat.try(:display)
    end
    @session_seat = SessionSeat.new if @session_seat.blank?
  end

  def update
    if params[:session_id].blank?
      redirect_to edit_event_session_seat_path(current_event, '~'), flash: {error: '请选择日程'}
      return
    end

    session = Session.find(params[:session_id])
    @session_seat = session.session_seat
    if @session_seat.blank?
      redirect_to edit_event_session_seat_path(current_event, '~'), flash: {error: '请先安排会议座位'}
      return
    end

    current_event.sessions.each do |session_item|
      if session_item.session_seat.present?
        session_item.session_seat.update(display: false)
      end
    end

    @session_seat.update(display: true)
    redirect_to edit_event_session_seat_path(current_event, '~'), flash: {success: '设置成功'}
  end

  def set_current_module
    @current_module = 2
  end
end
