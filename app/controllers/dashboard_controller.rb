class DashboardController < ApplicationController
  before_action :authorize_admin!

  def index
    @events = current_company.events.where(defunct: false).order(start: :DESC)
  end
end
