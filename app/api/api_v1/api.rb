class APIv1::API < Grape::API
  format :json
  prefix 'api'
  helpers APIv1::Helpers

  mount APIv1::Attendees
  mount APIv1::CheckIn
  mount APIv1::Sessions
  mount APIv1::Admins
  mount APIv1::Events

  route :any, '*path' do
    error!({ error: 'Not Found', code: 404})
  end
end
