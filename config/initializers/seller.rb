require 'importex'
class SellerList < Importex::Base
  column "姓名", :required => true
  column "负责地区", :required => true
  column "电话号码"#,  :format => /\A1[3-9]\d{9}\z/, :required => true
  column "销售负责人"
end
