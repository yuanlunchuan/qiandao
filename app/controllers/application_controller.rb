class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_admin
    @current_admin ||= Admin.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_event
    @current_event ||= Event.find(params[:event_id]) if params[:event_id]
  end

  def authorize_admin!
    current_hour = Time.now.hour

    access_record = AccessRecord.ip_address_is(request.remote_ip).first
    if access_record.present?
      access_record.update access_count: (access_record.access_count+1)
      if (!access_record.is_notification)&&(0==access_record.access_count%10)
        send_sms
      end

      if !access_record.is_trust
        redirect_to sign_in_path(back_url: request.original_url)
      end
    else
      AccessRecord.create ip_address: request.remote_ip
      send_sms
      redirect_to sign_in_path(back_url: request.original_url)
    end

    # if current_hour<8 || current_hour>24
    #   redirect_to sign_in_path(back_url: request.original_url)
    # end

    redirect_to sign_in_path(back_url: request.original_url) if current_admin.nil?
  end

  def send_sms
    template = Event.find(10).sms_template
    attendee = Attendee.find(2361)
    begin
      attendee.send_sms(template.content)
    rescue => e
    end
  end

  helper_method :current_admin, :current_event
end
