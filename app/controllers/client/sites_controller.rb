class Client::SitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'

  def show
    @attendee = Attendee.find(cookies[:attendee_id])
    @event = current_event
  end

  def download_qrcode
    attendee = current_event.attendees.find(params[:id])
    return redirect_to :back if attendee.rfid_num.blank?
    send_file "#{Rails.root}/public/attendee_qrcode/#{current_event.id}_#{attendee.id}.png", filename: "入场凭证.png", type: 'image/jpeg', disposition: 'attachment'
  end

end
