class DashboardController < ApplicationController
  before_action :authorize_admin!

  def index
    @events = Event.all.where(defunct: false).order('start')
  end
end
