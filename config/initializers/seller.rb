require 'importex'
class SellerList < Importex::Base
  column "name", :required => true
  column "responsible_area", :required => true
  column "phone_number"#,  :format => /\A1[3-9]\d{9}\z/, :required => true
  column "manager_name"
end
