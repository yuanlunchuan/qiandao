class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_admin
    @current_admin ||= Admin.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_event
    @current_event ||= Event.find(params[:event_id]) if params[:event_id]
  end

  def authorize_admin!
    access_record = AccessRecord.ip_address_is(request.remote_ip).first
    if access_record.present?
      access_record.update access_count: (access_record.access_count+1)
    else
      AccessRecord.create ip_address: request.remote_ip
    end

    # File.open("log/access_file","a+") do |file|
    #   if access_record.present?
    #     file.puts "id: #{request.remote_ip} time: #{access_record.access_count} url: #{request.original_url}"
    #   end
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
