class Client::RestaurantsController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  def show
    @restaurant = current_event.restaurant
  end
end
