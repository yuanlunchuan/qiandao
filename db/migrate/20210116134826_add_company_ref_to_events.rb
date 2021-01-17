class AddCompanyRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :company, index: true, foreign_key: true
  end
end
