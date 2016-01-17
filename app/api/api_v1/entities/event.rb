module APIv1
  module Entities
    class Event < Grape::Entity
      expose :id
      expose :name
      expose :start
      expose :end
    end
  end
end