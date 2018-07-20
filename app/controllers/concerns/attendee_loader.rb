module AttendeeLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_attendee
      if params[:attendee_id].present?&&params[:event_id].to_i==30
        session[:attendee_id]=params[:attendee_id]
        cookies[:attendee_id]=params[:attendee_id]
        return
      end

      if cookies[:attendee_id].blank?
        cookies[:attendee_id] = nil
        redirect_to new_client_event_session_path(current_event)
      else
        attendee = Attendee.find_by(id: cookies[:attendee_id])
        if attendee.present?&&attendee.event_id.present?&&attendee.event_id==current_event.id
          if current_event.id==attendee.event.id
            session[:attendee_id] = attendee.id
          else
            cookies[:attendee_id] = nil
            redirect_to new_client_event_session_path(current_event)
          end
        else
          cookies[:attendee_id] = nil
          redirect_to new_client_event_session_path(current_event)
        end
      end
    end
  end
end
