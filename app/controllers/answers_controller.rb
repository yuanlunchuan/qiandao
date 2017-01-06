class AnswersController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  layout 'event'

  def show
    
  end
end