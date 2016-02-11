class Client::RecommendsController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  def index
    @recommends = current_event.recommends
  end
end