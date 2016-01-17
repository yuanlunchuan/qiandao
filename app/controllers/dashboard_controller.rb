class DashboardController < ApplicationController
  before_action :authorize_admin!

  def index
    @events = Event.all.order(id: :desc)
  end
end
