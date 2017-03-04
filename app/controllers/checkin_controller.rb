require "set"
class CheckinController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module
  skip_before_action :verify_authenticity_token

  layout 'event'

  def index
  end

  def export
    @session = current_event.sessions.find(params[:session_id])
    @attendees = current_event.attendees
    render xlsx: 'export', filename: "#{Time.now.to_s(:url)}.xlsx"
  end

  def company_export
    @session = current_event.sessions.find(params[:session_id])
    @attendees1 = @session.attendees.unscope(:order).order('checkins.checked_in_at ASC')
    #@attendees2 = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).group(:company)
    @attendees2 = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).select('attendees.company').group(:company).reorder('attendees.company')
    render xlsx: 'company_export', filename: "#{Time.now.to_s(:url)}.xlsx"
  end

  def sessions
    @session = current_event.sessions.find(params[:session_id])
    return sessions_company if @session.company_checkin?

    params[:checked_in] ||= '0'

    @total = current_event.attendees.count
    @has_not_checkin_attendees = current_event.attendees.where.not(id: @session.attendees.pluck(:id))

    if params[:checked_in] == '0'
      @attendees = current_event.attendees
    elsif params[:checked_in] == '1'
      @attendees = @session.attendees.unscope(:order).order(checked_in_at: :desc)
    else
      @attendees = current_event.attendees.where.not(id: @session.attendees.pluck(:id))
    end

    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.page(params[:page]).includes(:category)

  end

  def uncheck_in
    @session = current_event.sessions.find(params[:session_id])
    @attendee = current_event.attendees.find(params[:attendee_id])
    @session.checkins.where(attendee: @attendee).destroy_all
    redirect_to :back, flash: {success: '取消签到成功'}
  end

  def check_in
    @session = current_event.sessions.find(params[:session_id])
    @attendee = current_event.attendees.find(params[:attendee_id])
    @session.checkins.create(attendee: @attendee) unless @session.checkins.where(attendee: @attendee).count > 0
    @attendee.update(checked_in_at: Time.now) if @attendee.checked_in_at.nil?
    redirect_to :back, flash: {success: '签到成功'}
  end

private

  def set_current_module
    @current_module = 3
  end

  def sessions_company
    params[:checked_in] ||= '1'

    @total = current_event.attendees.select(:company).distinct.count

    @has_not_checkin_attendees = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).select('attendees.company').group(:company).reorder('attendees.company')

    if params[:checked_in] == '0'
      @attendees = current_event.attendees.group(:company)
      @attendees = @attendees.page(params[:page]).per(200).includes(:category)
    elsif params[:checked_in] == '1'
      @attendees = @session.attendees
      @attendees = @attendees.page(params[:page]).per(200).includes(:category)
    else
      @attendees = current_event.attendees.where.not(company: @session.attendees.pluck(:company)).select('attendees.company').group(:company).reorder('attendees.company')

      @attendees = @attendees.page(params[:page]).per(200)#.includes(:category)
    end

    render 'sessions_company'
  end

end
