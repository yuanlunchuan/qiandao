class Client::SitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  skip_before_action :verify_authenticity_token
  include WebApiRenderer
  attr_accessor :meta

  def system_infos
    self.meta = params
    collection = []

    current_event.system_infos.visible.each do |system_info|
      collection << system_info.to_hash
    end

    render_not_found '没有系统消息' and return if collection.size==0

    render_ok collection
  end

  def show
    @attendee = Attendee.find(cookies[:attendee_id])
    @attendee.login_count = 0 if @attendee.login_count.blank?
    @attendee.update(login_count: (@attendee.login_count+1))
    @current_event_question = current_event.event_questions.active.first
    @img = if @attendee.avatar.exists?
         @attendee.avatar.url
       elsif @attendee.photo.exists?
         @attendee.photo.url(:square)
       end
    @event = current_event
  end

  def download_qrcode
    attendee = current_event.attendees.find(params[:id])
    return redirect_to :back if attendee.rfid_num.blank?
    send_file "#{Rails.root}/public/attendee_qrcode/#{current_event.id}_#{attendee.id}.png", filename: "入场凭证.png", type: 'image/jpeg', disposition: 'attachment'
  end

  def upload_photo
    @attendee = current_event.attendees.find(params[:id])
    @attendee.photo = params[:file]
    @attendee.save

    redirect_to client_event_sites_path(@attendee.event_id)

    # respond_to do |format|
    #   format.json {render json: {code: 0, message: 'ok'}}
    # end
  end

end
