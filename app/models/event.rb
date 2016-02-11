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

  has_many :question

  before_validation :generate_datetime
  after_find :build_time_attributes

  def start_time
    @start_time ||= '00:00'
  end

  def end_time
    @end_time ||= '00:00'
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
