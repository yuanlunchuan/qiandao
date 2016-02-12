class Client::SitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  skip_before_action :verify_authenticity_token

  def show
    @attendee = Attendee.find(cookies[:attendee_id])
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
    respond_to do |format|
      format.json {render json: {code: 0, message: 'ok'}}
    end
  end

end
