class Client::QuestionsController < ApplicationController
  layout 'client'

  def index

  end
  
  def create
    question = Question.new question_content: params[:question],
      event: current_event,
      event_question: EventQuestion.find(params[:event_question_id]),
      attendee: Attendee.find(cookies[:attendee_id])

    redirect_to client_event_event_question_questions_path(current_event, params[:event_question_id])
  end

  def new

  end
end