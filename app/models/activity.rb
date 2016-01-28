class Activity < ActiveRecord::Base
  belongs_to :event
  belongs_to :category, class_name: 'ActivityCategory'
end
