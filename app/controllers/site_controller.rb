class SiteController < ApplicationController
  before_action :authorize_admin!
  before_action :find_categories, except: [:search_attendee]
  before_action :find_session, except: [:index, :binding_rfid, :search_attendee]
  include WebApiRenderer
  attr_accessor :meta

  def sessions
  end

  def search_attendee
    self.meta = params

    attendee = Attendee.find_by(rfid_num: params[:keyword])
    attendee = Attendee.find_by(token: params[:keyword]) if attendee.blank?
    attendee = Attendee.find_by(name: params[:keyword]) if attendee.blank?
    attendee = Attendee.find_by(mobile: params[:keyword]) if attendee.blank?

    if attendee.present?
      render_ok [ attendee ]
    else
      render_not_found '没有找到'
    end
  end

  def search
    @attendees = current_event.attendees.contains(params[:keyword])

    render layout: false
  end

  def binding_rfid
    self.meta = params
    attendee = Attendee.find(params[:attendee_id])
    if attendee.update(rfid_num: params[:rfid_num])
      render_created [ attendee ]
    else
      render_conflict [], attendee.errors.full_messages
    end
  end

  def attendees
    @attendees = @session.attendees.unscope(:order).order('checkins.checked_in_at DESC')
    if @session.company_checkin?
      render 'companies', layout: false
    else
      render layout: false
    end
  end

  # POST /site/:session_id/check_in
  def check_in
    @attendee = current_event.attendees.find_by_rfid_num(params[:token])
    if !@attendee.present?
      @attendee = current_event.attendees.find_by_token(params[:token])
    end

    if @attendee.nil?
      return render json: {type: 'error', error: '找不到用户', code: -1}
    end
    session = @session.checkins.where(attendee: @attendee)

    return company_check_in if @session.company_checkin?
    # 已签到
    if @session.checkins.where(attendee: @attendee).count > 0
      return render json: {type: 'warning', error: '该用户已签到', message: "#{@attendee.name} / #{@attendee.mobile} / #{@attendee.company}", code: -2, attendee: attendee_info}
    end

    @session.checkins.create(attendee: @attendee)
    render json: {type: 0, code: 0 , attendee: attendee_info, html: render_to_string('_checkin_status', layout: false)}

  end

  def company_check_in
    colleagues = current_event.attendees.where(company:@attendee.company).pluck(:id)

    #-------------------------------
    #-There have modified by postgresql
    #checked_in_colleagues = @session.attendees.find(colleagues)
    checked_in_colleagues = @session.attendees.where(id: colleagues)

    #无人签到
    if checked_in_colleagues.to_a.count == 0
      @session.checkins.create(attendee: @attendee) unless @session.checkins.where(attendee: @attendee).count > 0
      @attendee.update(checked_in_at: Time.now) if @attendee.checked_in_at.nil?
      render json: {type: 0, code: 0 , attendee: attendee_info, html: render_to_string('_checkin_status_company', layout: false)}
    else
      return render json: {type: 'warning', error: @attendee.company, message: "贵公司的 #{checked_in_colleagues.first.name} 已领取", code: -2, attendee: attendee_info}
    end
  end

  def uncheck_in
    @attendee = current_event.attendees.find_by_token(params[:token])
    @session.checkins.where(attendee: @attendee).destroy_all
    render json: {code: 0}
  end

  def checkin
    @attendee = current_event.attendees.find_by_token(params[:token])

    if @attendee.nil?
      return render text: '用户不存在'
    end

    return company_checkin if @session.company_checkin?

    if @session.checkins.where(attendee: @attendee).count > 0
    else
      @session.checkins.create(attendee: @attendee) unless @session.checkins.where(attendee: @attendee).count > 0
      @attendee.update(checked_in_at: Time.now) if @attendee.checked_in_at.nil?
    end

    render layout: false

  end

private

  def attendee_info
    {  id: @attendee.id,
 rfid_num: @attendee.rfid_num,
     name: @attendee.name,
  company: @attendee.company,
   avatar: @attendee.avatar.url,
badge_url: badge_event_attendee_path(id: @attendee.id, format: :pdf, print: true),
  printed: @attendee.printed_at.present? ? true : false,
    }
  end

  def company_checkin
    colleagues = current_event.attendees.where(company:@attendee.company).pluck(:id)
    checked_in_colleagues = @session.attendees.where(id: colleagues)

    #无人签到
    if checked_in_colleagues.to_a.count == 0
      @session.checkins.create(attendee: @attendee) unless @session.checkins.where(attendee: @attendee).count > 0
      @attendee.update(checked_in_at: Time.now) if @attendee.checked_in_at.nil?
      render 'checkin', layout: false
    else
      render text: "<div class='text-center'><h3><i class='fa fa-times text-danger'></i> #{@attendee.company}</h3> <h3>贵公司的 #{checked_in_colleagues.first.name} 已领取</h3></div>"
    end
  end

  def find_categories
    @categories = current_event.attendee_categories
  end

  def find_session
    @session = current_event.sessions.find(params[:session_id])
  end

end
