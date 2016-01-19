class QuestionsController < ApplicationController
  layout 'event'

  def index
    @questions = current_event.question
  end

  def show
    @question = Question.find(params[:id])
    @answer   = Answer.new
  end

  def edit
    
  end

end