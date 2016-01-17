module APIv1
  class Sessions < Grape::API
    namespace :sessions do
      post '/new' do
        admin = Admin.find_by_name(params[:name])
        if admin && admin.authenticate(params[:password])
          present admin, with: APIv1::Entities::Admin, type: 'full'
        else
          error!({error: 'incorrect username or password', code: 400}, 400)
        end
      end
    end
  end
end