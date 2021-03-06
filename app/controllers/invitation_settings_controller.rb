class InvitationSettingsController < ApplicationController
  before_action :authorize_admin!

  layout 'event'

  def index
    @template = SmsTemplate.find_or_create_by(event: current_event)
    @sms_template = @template.content
    @settings = InvitationSetting.find_or_create_by(event: current_event)
    @current_module = 1
  end

  def update
    @current_module = 1

    @template = SmsTemplate.find_or_create_by(event: current_event)

    @settings = current_event.invitation_setting
    if @settings.update(settings_param)&&@template.update(content: params[:sms_template])
      redirect_to event_invitation_settings_path, flash: {success: '保存成功'}
    else
      flash.now[:error] = @settings.errors.full_messages
      render :index
    end
  end

private

  def settings_param
    params.require(:invitation_setting).permit(:content, :date, :check_in_time, :location, :address, :map_url, :event_alias, :photo)
  end
end
