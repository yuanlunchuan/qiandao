class DashboardController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!

  def index
    @events = Event.all.where(defunct: false).order(start: :DESC)
  end
end
