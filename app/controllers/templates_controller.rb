class TemplatesController < ApplicationController
  def show
    send_file "#{Rails.root}/public/files/"+params[:filename] unless params[:filename].blank?
  end
end
