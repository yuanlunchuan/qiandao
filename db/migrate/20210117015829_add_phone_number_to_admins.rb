class AddPhoneNumberToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :phone_number, :string
  end
end
