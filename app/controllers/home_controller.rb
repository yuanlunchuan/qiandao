class HomeController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  def index
    redirect_to '/app'
  end
end
