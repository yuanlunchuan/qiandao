class Client::InvitesController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  def show
  
  end
end
