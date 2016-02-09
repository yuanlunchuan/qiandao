class Client::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout 'client'
  def create
    attendees = Attendee.mobile_is(params[:phone_number])
    if attendees.present?
      session[:attendee_id] = attendees.first.id
      redirect_to client_event_sites_path(attendees.first.event.id)
    else
      render :new
    end
  end

  def new
    
  end

end
