module APIv1
  module Entities
    class Admin < Grape::Entity
      expose :id
      expose :name
      expose :auth_token
    end
  end
end