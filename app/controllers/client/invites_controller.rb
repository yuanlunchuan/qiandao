class Client::InvitesController < ApplicationController
  # include AttendeeLoader
  # before_action :load_attendee
  include WebApiRenderer
  attr_accessor :meta

  layout 'client'

  def event_info
    self.meta = params
    event = Event.find(params[:event_id])
    collection = []
    item = {}
    item = event.to_hash
    item['head_photo'] = event.head_photo.url
    item['event_logo'] = event.event_logo.url
    item['welcome_page_logo'] = event.welcome_page_logo.url
    item['welcome_bg'] = event.welcome_bg.url
    item['welcome_second_bg'] = event.welcome_second_bg.url
    collection << item

    render_ok collection
  end

  def show
    event = Event.find(params[:event_id])
    @welcome_bg = event.welcome_bg.url if event.welcome_bg.present?

    if cookies[:attendee_id].present?
      attendee = Attendee.find_by(id: cookies[:attendee_id])
      if attendee.present?&&attendee.event_id.present?&&attendee.event_id==current_event.id
        session[:attendee_id] = attendee.id
        cookies.permanent[:attendee_id] = attendee.id
        redirect_to client_event_sites_path(attendee.event.id)
      end
    end
  end
end
