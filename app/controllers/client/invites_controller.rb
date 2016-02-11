class Client::InvitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  def show
    if cookies[:attendee_id].present?
      attendee = Attendee.find_by(id: cookies[:attendee_id])
      if attendee.present?
        session[:attendee_id] = attendee.id
        cookies.permanent[:attendee_id] = attendee.id
        redirect_to client_event_sites_path(attendee.event.id)
      end
    end
  end
end
