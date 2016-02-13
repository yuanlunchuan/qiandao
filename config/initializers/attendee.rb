require 'importex'
# class AttendeeList < Importex::Base
#   column "rfid_num"
#   column "category_name"
#   column "gender"
#   column "name"
#   column "company"
#   column "mobile"
#   column "email"
#   column "province"
#   column "city"
# end
class AttendeeList < Importex::Base
  column "卡号"
  column "名字"
  column "性别"
  column "主嘉宾"
  column "对应销售"
  column "分类"
  column "级别"
  column "公司"
  column "手机号码"
  column "email"
  column "所在省"
  column "所在市"
end
