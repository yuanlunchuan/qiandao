module APIv1
  class Events < Grape::API
    namespace :events do
      before do
        authenticate!
      end

      get '/' do
        events = Event.all.order(id: :desc)
        present events, with: APIv1::Entities::Event
      end

      get '/:event_id/attendees' do
        attendees = if params[:checked_in]
          Event.find(params[:event_id]).attendees.checked_in.order(checked_in_at: :desc)
        else
          Event.find(params[:event_id]).attendees.order(created_at: :desc)
        end
        present attendees, with: APIv1::Entities::Attendee
      end

    end
  end
end