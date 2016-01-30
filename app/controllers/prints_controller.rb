class PrintsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    params[:printed] ||= '0'
    @attendees  = current_event.attendees.page(params[:page]).unscope(:order).order('printed_at DESC')
    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.printed if params[:printed] == '1'
    @attendees = @attendees.not_printed if params[:printed] == '-1'
  end

  def set_current_module
    @current_module = 3
  end
end
