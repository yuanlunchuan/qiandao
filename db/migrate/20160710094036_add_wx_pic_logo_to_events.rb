class AddWxPicLogoToEvents < ActiveRecord::Migration
  def change
    add_attachment :events, :wx_pic_logo
  end
end
