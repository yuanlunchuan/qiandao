class Client::SitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'

  def show
    @attendee = Attendee.find(cookies[:attendee_id])
    @event = current_event
  end

end
