class SessionSeat < ActiveRecord::Base
  belongs_to :session

  validates :total_table_count, presence: true, numericality: { integer_only: true }
  validates :per_table_num, presence: true, numericality: { integer_only: true }

end
