class AddActiveToEventQuestions < ActiveRecord::Migration
  def change
    add_column :event_questions, :active, :boolean, default: false
  end
end
