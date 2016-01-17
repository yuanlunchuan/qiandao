module APIv1
  class CheckIn < Grape::API
    namespace :check_in do
      before do
        authenticate!
      end

      get '/' do
        token = params[:token]
        return error!({error: 'Invalid Token', code: 1001}, 400) if token.nil?

        attendee = Attendee.find_by_token(token)

        return error!({error: 'Attendee Not Found', code: 1002}, 404) if attendee.nil?

        unless attendee.checked_in?
          attendee.update(checked_in_at: Time.now)
        end

        present attendee, with: APIv1::Entities::Attendee

      end
    end
  end
end