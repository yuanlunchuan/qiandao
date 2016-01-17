module APIv1
  class Admins < Grape::API
    namespace :admin do
      before do
        authenticate!
      end

      get '/hello' do
        present current_admin, with: APIv1::Entities::Admin
      end
    end
  end
end
