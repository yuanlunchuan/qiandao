class AddCompanyRefToAdmins < ActiveRecord::Migration
  def change
    add_reference :admins, :company, index: true, foreign_key: true
  end
end
