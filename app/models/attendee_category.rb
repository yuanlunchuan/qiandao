class AttendeeCategory < ActiveRecord::Base
  belongs_to :attendee
  belongs_to :event

  validates :name, presence: true
  has_many :lottery_prize_categories

  before_validation :populate_category_number, on: :create
  scope :category_name_is, ->(event, name) { where "event_id=? AND name=? ", event.id, name }
  def attendee_numbers
    Event.find(self.event_id).attendees.category(self.id).count
  end

  def checked_in_attendee_numbers(session_id)
    session = Event.find(self.event_id).sessions.find(session_id)
    session.attendees.where(category_id: self.id).unscope(:select).count
  end

  def company_numbers
    Event.find(self.event_id).attendees.where(category_id: self.id).select(:company).distinct.count
  end

  def to_hash
    hash = {}
    self.attributes.each { |k,v| hash[k] = v }
    return hash
  end

private

  def populate_category_number
    max_number = self.event.attendee_categories.maximum(:category_number) || 0
    self.category_number = max_number + 1
  end

end
