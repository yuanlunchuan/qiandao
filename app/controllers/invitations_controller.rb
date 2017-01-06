class InvitationsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  layout 'invitation'

  before_action :find_attendee, only: [:index, :show, :confirmation, :sessions, :done, :upload]

  skip_before_action :verify_authenticity_token, only: [:upload]


  def index
  end

  def confirmation
    @settings = @attendee.event.invitation_setting

    @img = if @attendee.avatar.exists?
             @attendee.avatar.url
           elsif @attendee.photo.exists?
             @attendee.photo.url(:square)
           end
  end

  def sessions
    @event = @attendee.event
    @sessions = @event.sessions.visible
    @schedule = Hash([])
    @sessions.each do |session|
      _,m,d = session.start_date.split('-')
      (@schedule["#{m}月#{d}日"] ||= []) << {time: "#{session.start_time}-#{session.end_time}", name: session.name}
    end
    @settings = @attendee.event.invitation_setting
  end

  def upload
    @attendee.photo = params[:file]
    @attendee.avatar = nil
    @attendee.save
    render json: {url: @attendee.photo.url(:square)}
  end

  def done
    @qr = RQRCode::QRCode.new(@attendee.qrcode, size: 5, level: :h)
    @settings = @attendee.event.invitation_setting
  end

private

  def find_attendee
    @attendee = Attendee.find_by_token(params[:attendee_token])
    render text: 'Attendee not found' unless @attendee
  end

end
