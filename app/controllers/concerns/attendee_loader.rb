module AttendeeLoader

  extend ActiveSupport::Concern

  self.included do |includer|

    def load_attendee
      if cookies[:attendee_id].blank?
        redirect_to new_client_session_path
      end
    end
  end
end
