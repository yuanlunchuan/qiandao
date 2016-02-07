class InvitationSetting < ActiveRecord::Base
  belongs_to :event
  has_attached_file :photo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/:event_id/attendees/:style/:attendee_number-:token.jpg',
                    default_url: 'avatar.png'
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
