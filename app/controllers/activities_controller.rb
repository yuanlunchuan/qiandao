class ActivitiesController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @activities = current_event.activities
  end

  def new
    @activity = current_event.activities.build
  end

  def create
    @activity = current_event.activities.new(activity_params)

    if @activity.save
      redirect_to event_activities_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @activity.errors.full_messages
      render :new
    end
  end

  def edit
    @activity = current_event.activities.find(params[:id])
  end

  def update
    @activity = current_event.activities.find(params[:id])

    if @activity.update(activity_params)
      redirect_to event_activities_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @activity.errors.full_messages
      render :edit
    end
  end

  def destroy
    @activity = current_event.activities.find(params[:id])
    @activity.destroy

    redirect_to event_activities_path
  end

  def set_current_module
    @current_module = 0
  end

  def activity_params
    params.require(:activity).permit(:name, :desc, :location, :start_time, :end_time, :start_date, :checkin_enabled, :company_checkin, :hidden, :question_enabled, :link)
  end

  private :activity_params, :set_current_module
end
