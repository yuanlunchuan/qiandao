class Client::RestaurantsController < ApplicationController
  include AttendeeLoader

  before_action :load_attendee
  layout 'client'
  def show
    @restaurant = Restaurant.find_or_create_by(event: current_event)
    #@restaurant = current_event.restaurant
  end
end
