class AddEventQuestionIdToQuestions < ActiveRecord::Migration
  def change
    add_reference :questions, :event_question
    add_column :questions, :praise_count, :integer, default: 0
    add_column :questions, :enable_display, :boolean, default: false
  end
end
