class NotificationsController < ApplicationController
  before_action :authorize_admin!
  before_action :check_sms_template, only: [:send_sms, :send_test_sms, :create]
  before_action :set_current_module

  layout 'event'

  def index
    params[:sent_sms] ||= '0'
    @attendees  = current_event.attendees.page(params[:page])
    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.sms_sent if params[:sent_sms] == '1'
    @attendees = @attendees.sms_not_sent if params[:sent_sms] == '-1'
  end

  def create
    params[:sent_sms] ||= '0'
    @attendees  = current_event.attendees.page(params[:page])
    @attendees = @attendees.category(params[:category_id]) if params[:category_id].present?
    @attendees = @attendees.contains(params[:keyword]) if params[:keyword].present?
    @attendees = @attendees.sms_sent if params[:sent_sms] == '1'
    @attendees = @attendees.sms_not_sent if params[:sent_sms] == '-1'

    success_count = 0
    error_count = 0

    @attendees.each do |attendee|
      begin
        attendee.send_sms(@template.content)
        success_count += 1
      rescue => e
        error_count += 1
        logger.info "--------e.message: #{e.message}"
        #redirect_to :back, flash: {error: e.message}
      end
    end
    redirect_to :back, flash: {success: "发送成功#{success_count}条, 失败#{error_count}条"}
  end

  def send_sms
    @attendee = current_event.attendees.find(params[:attendee_id])
    begin
      @attendee.send_sms(@template.content)
      redirect_to :back, flash: {success: '发送成功'}
    rescue => e
      redirect_to :back, flash: {error: e.message}
    end
  end

  def send_test_sms
  end

  def edit_sms_template
    @template = SmsTemplate.find_or_create_by(event: current_event)
  end

  def update_sms_template
    @template = current_event.sms_template
    if @template.update(sms_template_params)
      redirect_to event_notifications_path, flash: { success: '保存成功'}
    else
      flash.now[:error] = @template.errors.full_messages
      render :edit_sms_template
    end
  end

  def set_current_module
    @current_module = 1
  end

private
  def check_sms_template
    @template = current_event.sms_template
    return redirect_to event_notifications_path, flash: { error: '还没有添加短信模板' } if @template.blank?
  end

  def sms_template_params
    params.require(:sms_template).permit(:content, :sign)
  end
end
