class SystemInfosController < ApplicationController
  http_basic_authenticate_with name: Rails.configuration.authen_name, password: Rails.configuration.password
  before_action :authorize_admin!
  before_action :set_current_module

  layout 'event'

  def index
    @system_infos = current_event.system_infos
  end

  def new
    @system_info = current_event.system_infos.build
  end

  def create
    @system_info = current_event.system_infos.new(system_info_params)

    if @system_info.save
      redirect_to event_system_infos_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @system_info.errors.full_messages
      render :new
    end
  end

  def edit
    @system_info = current_event.system_infos.find(params[:id])
  end

  def update
    @system_info = current_event.system_infos.find(params[:id])

    if @system_info.update(system_info_params)
      redirect_to event_system_infos_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @system_info.errors.full_messages
      render :edit
    end
  end

  def destroy
    @system_info = current_event.system_infos.find(params[:id])
    @system_info.destroy

    redirect_to event_system_infos_path
  end

  def set_current_module
    @current_module = 1
  end

  def system_info_params
    params.require(:system_info).permit(:content, :display)
  end

  private :system_info_params, :set_current_module
end