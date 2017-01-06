class TemplatesController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  def show
    send_file "#{Rails.root}/public/files/"+params[:filename] unless params[:filename].blank?
  end
end
