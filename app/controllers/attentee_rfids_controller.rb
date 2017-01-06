class AttenteeRfidsController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    params[:has_photo]  ||= '0'
    params[:has_avatar] ||= '0'
    @attendees = current_event.attendees
    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.has_photo if params[:has_photo] == '1'
    @attendees = @attendees.has_avatar if params[:has_avatar] == '1'
    @attendees = @attendees.does_not_have_photo  if params[:has_photo] == '-1'
    @attendees = @attendees.does_not_have_avatar if params[:has_avatar] == '-1'
    @attendees = @attendees.does_not_processed_avatar if params[:has_avatar] == '-2'
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.page(params[:page]).includes(:category)
  end

  def edit
    @attendee = current_event.attendees.find(params[:id])
  end

  def update
    @attendee = current_event.attendees.find(params[:id])
    
    if @attendee.update(attendee_params)
      redirect_to event_attentee_rfids_path(current_event), flash: {success: '编辑成功'}
    else
      flash.now[:error] = @attendee.errors.full_messages
      render :edit
    end
  end

  def set_current_module
    @current_module = 2
  end

  def attendee_params
    params.require(:attendee).permit(:rfid_num)
  end

  private :set_current_module
end
