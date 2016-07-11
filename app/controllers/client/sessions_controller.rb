class Client::SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  layout 'client'
  def create
    attendees = current_event.attendees.mobile_is(params[:phone_number])
    if attendees.present?
      cookies.permanent[:attendee_id] = attendees.first.id
      attendee = attendees.first

      redirect_to client_event_sites_path(current_event)
    else
      flash.now[:error] = '该用户不存在请重新输入'
      render :new
    end
  end

  def new
    if cookies[:attendee_id].present?
      attendee = Attendee.find_by(id: cookies[:attendee_id])
      if attendee.present?&&attendee.event_id.present?&&attendee.event_id==current_event.id
        redirect_to client_event_sites_path(attendee.event.id)
      end
    end
  end

end
