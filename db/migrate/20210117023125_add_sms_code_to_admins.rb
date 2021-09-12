class AddSmsCodeToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :regist_sms_code, :string
    add_column :admins, :regist_sms_code_create, :datetime
    add_column :admins, :active, :boolean
  end
end
