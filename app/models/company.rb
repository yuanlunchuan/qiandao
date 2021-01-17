class Company < ActiveRecord::Base
    has_many :admins
    has_many :events

end
