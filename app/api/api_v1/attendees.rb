module APIv1
  class Attendees < Grape::API
    namespace :attendees do
      before do
        authenticate!
      end

      get '/' do
      end
    end
  end
end