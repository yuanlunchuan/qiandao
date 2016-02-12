module AttendeeLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_attendee
      if cookies[:attendee_id].blank?
        cookies[:attendee_id] = nil
        redirect_to new_client_session_path
      else
        attendee = Attendee.find_by(id: cookies[:attendee_id])
        if attendee.present?
          if current_event.id==attendee.event.id
            session[:attendee_id] = attendee.id
          else
            cookies[:attendee_id] = nil
            redirect_to new_client_session_path
          end
        else
          cookies[:attendee_id] = nil
          redirect_to new_client_session_path
        end
      end
    end
  end
end
