class RedirectsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  def show
    redirect_to client_invites_path
  end

end