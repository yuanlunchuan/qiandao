class Session < ActiveRecord::Base
  belongs_to :event
  has_many :checkins, dependent: :destroy
  validates :contact_phone_number, length: { is: 11 }, numericality: { integer_only: true }, format: { with: /\A1[3-9]\d{9}\z/ }, allow_blank: true
  # This is wrong in postgresql
  # has_many :attendees, -> { select('attendees.*, checkins.checked_in_at as session_checked_in_at').order('`checkins`.checked_in_at DESC') }, through: :checkins
  has_many :attendees, -> { select('attendees.*, checkins.checked_in_at as session_checked_in_at').order('checkins.checked_in_at DESC') }, through: :checkins
  has_many :seats
  has_one  :session_seat
  belongs_to :session_location
  default_scope -> { order(starts_at: :asc) }

  scope :visible, -> { where(hidden: false) }
  scope :checkin_enabled, -> { where(checkin_enabled: true)}

  attr_accessor :start_time, :end_time
  attr_accessor :start_date
  attr_accessor :day_of_week

  before_validation :generate_datetime
  after_initialize :init_default_info

  validates :starts_at, presence: true
  validates :name, presence: true

  def start_time
    @start_time ||= '00:00'
  end

  def end_time
    @end_time ||= '00:00'
  end

  def timezone
    @timezone ||= self.event.try(:time_zone) || 'Beijing'
  end

  def day_of_week_in_chinese
    return '' unless @day_of_week

    ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'][@day_of_week.to_i]
  end

  def full_name
    "#{start_date} #{start_time} #{name}"
  end

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end

private

  def generate_datetime
    self.starts_at =  Time.use_zone(self.timezone) { Time.zone.parse("#{self.start_date} #{self.start_time}") } if self.start_date.present?
    self.ends_at =  Time.use_zone(self.timezone)   { Time.zone.parse("#{self.start_date} #{self.end_time}") } if self.start_date.present?
  end

  def init_default_info
    return unless self.event
    # comment by yuan lunchuan
    #self.starts_at ||= self.event.starts_at
    #self.ends_at   ||= self.event.ends_at

    @start_time = self.starts_at.in_time_zone(self.timezone).strftime('%H:%M') if self.starts_at
    @end_time   = self.ends_at.in_time_zone(self.timezone).strftime('%H:%M') if self.ends_at

    @start_date = self.starts_at.in_time_zone(self.timezone).strftime('%Y-%m-%d') if self.starts_at
    @day_of_week  = self.starts_at.in_time_zone(self.timezone).strftime('%w') if self.starts_at
  end

end
