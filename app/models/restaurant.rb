class Restaurant < ActiveRecord::Base
  belongs_to :event
  has_attached_file :head_photo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/restaurant/:style/:event.jpg',
                    default_url: '/images/default-bg.png'
  validates_attachment_content_type :head_photo, :content_type => /\Aimage\/.*\Z/
end
