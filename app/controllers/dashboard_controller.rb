class DashboardController < ApplicationController
  before_action :authorize_admin!

  def index
    @events = Event.all.order('start')
  end
end
