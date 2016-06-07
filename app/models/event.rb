class Event < ActiveRecord::Base
  attr_accessor :start_time
  attr_accessor :end_time

  validates :name, presence: true
  validates :start, presence: true
  validates :end, presence: true

  has_many :attendees
  has_many :attendee_categories
  has_many :sessions
  has_one  :sms_template
  has_one  :invitation_setting
  has_many :activity_categories
  has_many :activities
  has_many :sellers
  has_many :recommends
  has_one  :restaurant
  has_many  :system_infos
  has_many :session_locations

  has_many :question
  has_many :event_lottery_prizes
  has_many :lottery_prizes

  before_validation :generate_datetime
  after_find :build_time_attributes

  has_attached_file :head_photo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/head_photo/:style/:event.jpg',
                    default_url: '/images/default-bg.png'

  has_attached_file :event_logo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/event_logo/:style/:event.jpg',
                    default_url: '/images/default_logo.png'

  has_attached_file :welcome_page_logo,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/welcome_page_logo/:style/:event.jpg',
                    default_url: '/images/default_logo.png'

  has_attached_file :welcome_bg,
                    styles: { medium: "300x300>", square:'300x300#', thumb: "100x100>", large: '1000x1000>'},
                    url: '/system/events/welcome_bg/:style/:event.jpg',
                    default_url: '/images/default-welcome-bg.png'

  validates_attachment_content_type :head_photo, :content_type => /\Aimage\/.*\Z/
  def start_time
    @start_time ||= '00:00'
  end

  def end_time
    @end_time ||= '00:00'
  end

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end

private

  def build_time_attributes
    @start_time = self.starts_at.in_time_zone(self.time_zone).strftime('%H:%M') if self.starts_at
    @end_time   = self.ends_at.in_time_zone(self.time_zone).strftime('%H:%M') if self.ends_at
  end

  def generate_datetime
    self.starts_at =  Time.use_zone(self.time_zone) { Time.zone.parse("#{self.start} #{self.start_time}") }
    self.ends_at =  Time.use_zone(self.time_zone) { Time.zone.parse("#{self.end} #{self.end_time}") }
  end
end
