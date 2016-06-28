class RemoveSessionIdFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :session_id, :integer
  end
end
