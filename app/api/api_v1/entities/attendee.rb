module APIv1
  module Entities
    class Attendee < Grape::Entity
      expose :id
      expose :name
      expose :company
      expose :mobile
      expose :created_at
      expose :checked_in_at
    end
  end
end
