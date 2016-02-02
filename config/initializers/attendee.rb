require 'importex'
class AttendeeList < Importex::Base
  column "rfid_num"
  column "category_name"
  column "gender"
  column "name"
  column "company"
  column "mobile"
  column "email"
  column "province"
  column "city"
end
