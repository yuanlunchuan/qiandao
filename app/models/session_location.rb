class SessionLocation < ActiveRecord::Base
	belongs_to :event
	has_many :sessions
end
